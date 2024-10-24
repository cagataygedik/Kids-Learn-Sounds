//
//  KLSListViewController.swift
//  Animal Sounds
//
//  Created by Celil Çağatay Gedik on 4.10.2024.
//

import UIKit
import RevenueCat
import RevenueCatUI
import SkeletonView

final class KLSListViewController: UIViewController {
    private var collectionView: UICollectionView!
    private var viewModel = KLSListViewModel()
    private var activeCellId: Int?
    private var endpoint: KLSEndpoint
    private let searchBar = UISearchBar()
    private var activityIndicator: UIActivityIndicatorView?
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, KLSModel>!
    
    init(endpoint: KLSEndpoint) {
        self.endpoint = endpoint
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Purchases.shared.delegate = self
        setupViewController()
        bindViewModels()
        observeEntitlementChanges()
    }
    
    private func setupViewController() {
        configureNavigationBar()
        configureCollectionView()
        configureDataSource()
        addSearchBar()
        viewModel.fetchItems(for: endpoint)
    }
    
    private func bindViewModels() {
        viewModel.onItemsUpdated = { [weak self] newItemsCount in
            self?.applySnapshot(animatingDifferences: true)
        }
        
        viewModel.onLoadingStateChanged = { [weak self] isLoading in
            if isLoading {
                self?.showLoadingView()
            } else {
                self?.hideLoadingView()
            }
        }
        
        viewModel.showError = { [weak self] error, endpoint in
            self?.presentErrorAlert(with: error, for: endpoint)
        }
    }
    
    private func showLoadingView() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        guard let activityIndicator = activityIndicator else { return }
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .darkGray
        view.addSubview(activityIndicator)
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalTo(view)
        }
        
        activityIndicator.startAnimating()
    }
    
    private func hideLoadingView() {
        guard let activityIndicator = activityIndicator else { return }
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
        self.activityIndicator = nil
    }
    
    func applySnapshot(animatingDifferences: Bool = true) {
        guard !viewModel.filteredItems.isEmpty else {
//            showLoadingView()
            return
        }

        var snapshot = NSDiffableDataSourceSnapshot<Int, KLSModel>()
        snapshot.appendSections([0])
        snapshot.appendItems(viewModel.filteredItems)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    private func reloadItems(for item: KLSModel) {
        guard let index = viewModel.filteredItems.firstIndex(of: item) else { return }
        var snapshot = dataSource.snapshot()
        viewModel.updateCustomerInfo(viewModel.customerInfo!)
        snapshot.reloadItems([viewModel.filteredItems[index]])
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func presentErrorAlert(with error: KLSError, for endpoint: KLSEndpoint) {
        let alertViewController = KLSAlertViewController(
            title: NSLocalizedString("error_title", comment: "Error title for alert"),
            message: error.localizedDescription)
        alertViewController.retryAction = { [weak self] in
            self?.viewModel.fetchItems(for: endpoint)
        }
        alertViewController.modalPresentationStyle = .overFullScreen
        alertViewController.modalTransitionStyle = .crossDissolve
        self.present(alertViewController, animated: true)
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.tintColor = Constants.mainAppColor
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let upgradeButton = UIBarButtonItem(
            title: NSLocalizedString("upgrade_button_title", comment: "Upgrade button title"),
            style: .plain,
            target: self,
            action: #selector(upgradeButtonTapped))
        navigationItem.rightBarButtonItem = upgradeButton
    }
    
    @objc private func upgradeButtonTapped() {
        checkAndShowPaywallIfNeeded()
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.register(KLSListCell.self, forCellWithReuseIdentifier: KLSListCell.reuseID)
        configureDataSource()
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, KLSModel>(collectionView: collectionView) { [weak self] (collectionView, indexPath, item) -> UICollectionViewCell? in
            guard let self = self else { return nil }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KLSListCell.reuseID, for: indexPath) as! KLSListCell
            let viewModel = KLSListCellViewModel(item: item, customerInfo: self.viewModel.customerInfo)
            cell.viewModel = viewModel
            return cell
        }
    }
    
    private func addSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = NSLocalizedString("search", comment: "Search placeholder text")
        searchBar.searchTextField.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("search", comment: "Search placeholder text"), attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        searchBar.searchTextField.leftView?.tintColor = .lightGray
        searchBar.searchTextField.textColor = .black
        //TODO: UISearchBar clear button color change
        navigationItem.titleView = searchBar
    }
}

extension KLSListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.filteredItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KLSListCell.reuseID, for: indexPath) as! KLSListCell
        let item = viewModel.filteredItems[indexPath.item]
        cell.viewModel = KLSListCellViewModel(item: item)
        
        updateCellProgress(cell, for: item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        searchBar.resignFirstResponder()
        let selectedItem = viewModel.filteredItems[indexPath.item]
        
        if selectedItem.isPremium {
            Purchases.shared.getCustomerInfo { [weak self] (customerInfo, error) in
                guard let self = self else { return }
                guard error == nil else {
                    print("Error fetching customer info: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                if let info = customerInfo {
                    self.viewModel.updateCustomerInfo(info)
                }
                
                if let customerInfo = customerInfo, customerInfo.entitlements["premium"]?.isActive == true {
                    handleItemSelection(for: selectedItem, at: indexPath)
                } else {
                    self.presentPaywall()
                }
            }
        } else {
            handleItemSelection(for: selectedItem, at: indexPath)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.height
        
        if offsetY >= contentHeight - frameHeight - 200 {
            viewModel.loadMoreItems(for: endpoint)
        }
    }
    
    private func updateCellProgress(_ cell: KLSListCell, for item: KLSModel) {
        if item.id == viewModel.activeItemId {
            let remainingDuration = SoundManager.shared.getRemainingTime(for: item.id, from: item.sound)
            DispatchQueue.main.async {
                cell.showProgress(duration: remainingDuration)
            }
        } else {
            DispatchQueue.main.async {
                cell.hideProgress()
            }
        }
    }
    
    private func handleItemSelection(for selectedItem: KLSModel, at indexPath: IndexPath) {
        if let activeItemId = viewModel.activeItemId, activeItemId != selectedItem.id {
            SoundManager.shared.stopSound()
            resetPreviousActiveItem()
        }
        playSound(for: selectedItem, at: indexPath)
    }
    
    private func resetPreviousActiveItem() {
        if let activeItemId = viewModel.activeItemId,
           let activeIndex = viewModel.filteredItems.firstIndex(where: { $0.id == activeItemId }) {
            if let previousCell = collectionView.cellForItem(at: IndexPath(item: activeIndex, section: 0)) as? KLSListCell {
                DispatchQueue.main.async {
                    previousCell.hideProgress()
                }
            }
        } else {
            collectionView.reloadData()
        }
    }
    
    private func playSound(for item: KLSModel, at indexPath: IndexPath) {
        if let soundPath = item.sound {
            SoundManager.shared.playSound(for: item.id, from: soundPath)
        }
        
        viewModel.activeItemId = item.id
        if let cell = collectionView.cellForItem(at: indexPath) as? KLSListCell {
            let duration = SoundManager.shared.getSoundDuration(from: item.sound)
            DispatchQueue.main.async {
                cell.showProgress(duration: duration)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [weak self] in
                self?.finalizeSoundProgress(for: item, cell: cell)
            }
        }
    }
    
    private func finalizeSoundProgress(for item: KLSModel, cell: KLSListCell) {
        if viewModel.activeItemId == item.id {
            cell.hideProgress()
            viewModel.activeItemId = nil
        }
    }
    
    private func observeEntitlementChanges() {
        Purchases.shared.getCustomerInfo { [weak self] (customerInfo, error) in
            guard let self = self else { return }
            guard error == nil else {
                print("Error fetching customer info: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            if let customerInfo = customerInfo, customerInfo.entitlements["premium"]?.isActive == true {
                self.viewModel.updateCustomerInfo(customerInfo)
                self.viewModel.fetchItems(for: self.endpoint)
                
                for item in self.viewModel.filteredItems {
                    self.reloadItems(for: item)
                }
            }
        }
    }
}

extension KLSListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterItems(with: searchText)
        applySnapshot(animatingDifferences: true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        viewModel.filterItems(with: "")
        applySnapshot(animatingDifferences: true)
    }
}

extension KLSListViewController: PurchasesDelegate {
    func purchases(_ purchases: Purchases, receivedUpdated customerInfo: CustomerInfo) {
        DispatchQueue.main.async {
            self.viewModel.updateCustomerInfo(customerInfo)
            
            for item in self.viewModel.filteredItems {
                self.reloadItems(for: item)
            }
//            self.applySnapshot(animatingDifferences: true)
        }
    }
}

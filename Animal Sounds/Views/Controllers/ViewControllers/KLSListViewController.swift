//
//  KLSListViewController.swift
//  Animal Sounds
//
//  Created by Celil Çağatay Gedik on 4.10.2024.
//

import UIKit
import SkeletonView
import RevenueCat
import RevenueCatUI

final class KLSListViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    private var viewModel = KLSListViewModel()
    private var activeCellId: Int?
    private var endpoint: KLSEndpoint
    private let searchBar = UISearchBar()
    
    init(endpoint: KLSEndpoint) {
        self.endpoint = endpoint
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        bindViewModels()
        startSkeletonLoading()
    }
    
    private func setupViewController() {
        configureNavigationBar()
        configureCollectionView()
        addSearchBar()
        //        addSearchController()
        viewModel.fetchItems(for: endpoint)
    }
    
    private func bindViewModels() {
        viewModel.onItemsUpdated = { [weak self] in
            self?.reloadData()
        }
        
        viewModel.showError = { [weak self] error, endpoint in
            self?.presentErrorAlert(with: error, for: endpoint)
        }
    }
    
    private func reloadData() {
        stopSkeletonLoading()
        collectionView.reloadData()
    }
    
    func startSkeletonLoading() {
        //This should've solved the bug, it solved a little bit, but not fully solved
        DispatchQueue.main.async {
            self.collectionView.showAnimatedGradientSkeleton()
        }
    }
    
    private func stopSkeletonLoading() {
        DispatchQueue.main.async {
            self.collectionView.hideSkeleton()
        }
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
        collectionView.isSkeletonable = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.register(KLSListCell.self, forCellWithReuseIdentifier: KLSListCell.reuseID)
    }
    
    private func addSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = NSLocalizedString("search", comment: "Search placeholder text")
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
        handleItemSelection(for: selectedItem, at: indexPath)
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
}

extension KLSListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterItems(with: searchText)
        collectionView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        viewModel.filterItems(with: "")
        collectionView.reloadData()
    }
    
}

extension KLSListViewController: SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return KLSListCell.reuseID
    }
}

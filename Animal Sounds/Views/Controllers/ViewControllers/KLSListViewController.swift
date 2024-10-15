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
    private var searchWorkItem: DispatchWorkItem?
    
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
        addSearchController()
        viewModel.fetchItems(for: endpoint)
    }
    
    private func bindViewModels() {
        viewModel.onItemsUpdated = { [weak self] in
            self?.stopSkeletonLoading()
            self?.collectionView.reloadData()
        }
        
        viewModel.showError = { [weak self] error, endpoint in
            self?.showErrorAlert(with: error, for: endpoint)
        }
    }
    
    func startSkeletonLoading() {
        //This should've solved the bug, it solved a little bit, but not fully solved
        DispatchQueue.main.async {
            self.collectionView.showAnimatedGradientSkeleton()
        }
    }
    
    private func stopSkeletonLoading() {
        collectionView.hideSkeleton()
    }
    
    private func showErrorAlert(with error: KLSError, for endpoint: KLSEndpoint) {
        DispatchQueue.main.async {
            let alertViewController = KLSAlertViewController(
                title: NSLocalizedString("error_title", comment: "Error title for alert"),
                message: error.localizedDescription)
            alertViewController.retryAction = { [weak self] in
                self?.viewModel.fetchItems(for: endpoint)
            }
            alertViewController.modalPresentationStyle = .overFullScreen
            alertViewController.modalTransitionStyle = .crossDissolve
            self.present(alertViewController, animated: true, completion: nil)
        }
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
    
    private func addSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
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
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = viewModel.filteredItems[indexPath.item]
        
        // Stop the previous sound and reset progress if a new item is selected
        if let activeCellId = activeCellId, activeCellId != selectedItem.id {
            SoundManager.shared.stopSound()
            if let activeIndex = viewModel.items.firstIndex(where: { $0.id == activeCellId }),
               let previousCell = collectionView.cellForItem(at: IndexPath(item: activeIndex, section: 0)) as? KLSListCell {
                previousCell.hideProgress()
            }
        }
        
        if let soundPath = selectedItem.sound {
            SoundManager.shared.playSound(from: soundPath)
        }
        
        // Store the active item id to track the currently playing sound
        activeCellId = selectedItem.id
        
        if let cell = collectionView.cellForItem(at: indexPath) as? KLSListCell {
            DispatchQueue.main.async {
                cell.showProgress(duration: SoundManager.shared.getSoundDuration(from: selectedItem.sound))
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + SoundManager.shared.getSoundDuration(from: selectedItem.sound)) { [weak self] in
                cell.hideProgress()
                self?.activeCellId = nil
            }
        }
    }
}

extension KLSListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        searchWorkItem?.cancel()
        
        let newWorkItem = DispatchWorkItem { [weak self] in
            self?.viewModel.filterItems(with: searchText)
        }
        
        searchWorkItem = newWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: newWorkItem)
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

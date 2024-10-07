//
//  KLSListViewController.swift
//  Animal Sounds
//
//  Created by Celil Çağatay Gedik on 4.10.2024.
//

import UIKit

final class KLSListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchResultsUpdating {
    
    private var collectionView: UICollectionView!
    private var viewModel = KLSListViewModel()
    private var activeCell: KLSListCell?
    private var endpoint: KLSEndpoint
    
    init(endpoint: KLSEndpoint) {
        self.endpoint = endpoint
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.loadItems(for: endpoint)
        configureViewController()
        configureCollectionView()
        addSearchController()
        
        viewModel.onItemsUpdated = { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    private func configureViewController() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = viewModel.filteredItems[indexPath.item]
        
        if let soundPath = selectedItem.sound {
            SoundManager.shared.playSound(from: soundPath)
        }
        
        if let cell = collectionView.cellForItem(at: indexPath) as? KLSListCell {
            activeCell?.hideProgress()
            activeCell = cell
            cell.showProgress(duration: SoundManager.shared.getSoundDuration(from: selectedItem.sound))
            
            DispatchQueue.main.asyncAfter(deadline: .now() + SoundManager.shared.getSoundDuration(from: selectedItem.sound)) { [weak self] in
                
                cell.hideProgress()
                self?.activeCell = nil
                
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.filteredItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KLSListCell.reuseID, for: indexPath) as! KLSListCell
        let item = viewModel.filteredItems[indexPath.item]
        cell.viewModel = KLSListCellViewModel(item: item)
        return cell
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        viewModel.filterItems(with: searchText)
    }
}


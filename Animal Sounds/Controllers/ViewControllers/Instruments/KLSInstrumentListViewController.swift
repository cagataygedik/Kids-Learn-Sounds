//
//  FavoritesListViewController.swift
//  Animal Sounds
//
//  Created by Celil Çağatay Gedik on 4.05.2024.
//

import UIKit

final class KLSInstrumentListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchResultsUpdating {
    private var collectionView: UICollectionView!
    private let instruments = KLSInstrumentsData.instruments.sorted { $0.name < $1.name }
    private var filteredInstruments: [KLSMainModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        addSearchController()
        configureCollectionView()
        filteredInstruments = instruments
    }
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        addNavigationItems()
    }
    
    private func addNavigationItems() {
        let removeAdsButton = UIBarButtonItem(title: "Remove Ads", style: .plain, target: self, action: #selector(removeAdsButtonTapped))
        
        let settingsButton = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(settingsButtonTapped))
        
        navigationItem.rightBarButtonItems = [settingsButton, removeAdsButton]
    }
    
    @objc private func removeAdsButtonTapped() {
        print("test")
    }
    
    @objc private func settingsButtonTapped() {
        print("settings")
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(KLSMainCell.self, forCellWithReuseIdentifier: KLSMainCell.reuseID)
    }
    
    private func addSearchController() {
        let searchController = setupSearchController(searchBarPlaceholder: "Search for a instrument", searchResultsUpdater: self)
        navigationItem.searchController = searchController
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredInstruments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KLSMainCell.reuseID, for: indexPath) as! KLSMainCell
        let instruments = filteredInstruments[indexPath.item]
        cell.set(item: instruments)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedInstrument = filteredInstruments[indexPath.item]
        SoundManager.shared.playSound(soundFileName: selectedInstrument.soundFileName)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        if searchText.isEmpty {
            filteredInstruments = instruments
        } else {
            filteredInstruments = instruments.filter({ $0.name.lowercased().contains(searchText.lowercased()) })
        }
        UIView.transition(with: collectionView, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.collectionView.reloadData()
        }, completion: nil)
    }
}

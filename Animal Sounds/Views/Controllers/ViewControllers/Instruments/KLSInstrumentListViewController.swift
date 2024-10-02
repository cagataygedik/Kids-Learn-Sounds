//
//  FavoritesListViewController.swift
//  Animal Sounds
//
//  Created by Celil Çağatay Gedik on 4.05.2024.
//

import UIKit

import UIKit

final class KLSInstrumentListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchResultsUpdating {
    
    private var collectionView: UICollectionView!
    private var viewModel: KLSInstrumentListViewModel!
    private var activeCell: KLSMainCell?
    
    private var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = KLSInstrumentListViewModel(instruments: KLSInstrumentsData.instruments)
        configureViewController()
        addSearchController()
        configureCollectionView()
        
        // Bind the ViewModel to UI updates
        viewModel.onInstrumentsUpdated = { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        addNavigationItems()
    }
    
    private func addNavigationItems() {
        let removeAdsButton = UIBarButtonItem(title: "Go Premium", style: .plain, target: self, action: #selector(removeAdsButtonTapped))
        navigationItem.rightBarButtonItem = removeAdsButton
    }
    
    @objc private func removeAdsButtonTapped() {
        print("test")
    }
    
    @objc private func settingsButtonTapped() {
        let settingsViewController = KLSSettingsViewController()
        navigationController?.pushViewController(settingsViewController, animated: true)
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
        let searchController = setupSearchController(searchBarPlaceholder: "Search for an instrument", searchResultsUpdater: self)
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.filteredInstruments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KLSMainCell.reuseID, for: indexPath) as! KLSMainCell
        let instrument = viewModel.filteredInstruments[indexPath.item]
        cell.set(item: instrument)
        
        if let activeInstrument = viewModel.activeInstrument, activeInstrument.name == instrument.name {
            cell.showProgress(duration: SoundManager.shared.getSoundDuration(soundFileName: instrument.soundFileName))
            activeCell = cell
        } else {
            cell.hideProgress()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let soundDuration = viewModel.selectInstrument(at: indexPath.item)
        SoundManager.shared.playSound(soundFileName: viewModel.filteredInstruments[indexPath.item].soundFileName)
        
        activeCell?.hideProgress()
        if let cell = collectionView.cellForItem(at: indexPath) as? KLSMainCell {
            activeCell = cell
            cell.showProgress(duration: soundDuration)
            DispatchQueue.main.asyncAfter(deadline: .now() + soundDuration) {
                if self.viewModel.activeInstrument == self.viewModel.filteredInstruments[indexPath.item] {
                    cell.hideProgress()
                    self.activeCell = nil
                    self.viewModel.resetActiveInstrument()
                }
            }
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        viewModel.filterInstruments(with: searchText)
    }
}

extension KLSInstrumentListViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.filterInstruments(with: "")
        collectionView.reloadData()
        
        if let activeInstrument = viewModel.activeInstrument, let activeIndex = viewModel.filteredInstruments.firstIndex(where: { $0.name == activeInstrument.name }) {
            let indexPath = IndexPath(item: activeIndex, section: 0)
            if let cell = collectionView.cellForItem(at: indexPath) as? KLSMainCell {
                let soundDuration = SoundManager.shared.getSoundDuration(soundFileName: activeInstrument.soundFileName)
                cell.showProgress(duration: soundDuration)
                activeCell = cell
                
                DispatchQueue.main.asyncAfter(deadline: .now() + soundDuration) {
                    if self.viewModel.activeInstrument == activeInstrument {
                        cell.hideProgress()
                        self.activeCell = nil
                        self.viewModel.resetActiveInstrument()
                    }
                }
            }
        }
    }
}


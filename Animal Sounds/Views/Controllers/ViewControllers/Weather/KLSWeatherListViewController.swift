//
//  KLSWeatherListViewController.swift
//  Animal Sounds
//
//  Created by Celil Çağatay Gedik on 7.05.2024.
//

import UIKit

final class KLSWeatherListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchResultsUpdating {
    
    private var collectionView: UICollectionView!
    private var viewModel: KLSWeatherListViewModel!
    private var activeCell: KLSMainCell?
    
    private var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = KLSWeatherListViewModel(weather: KLSWeatherData.weather)
        configureViewController()
        addSearchController()
        configureCollectionView()
        
        viewModel.onWeatherUpdated = { [weak self] in
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
        print("Remove Ads tapped")
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
        let searchController = setupSearchController(searchBarPlaceholder: "Search for a weather", searchResultsUpdater: self)
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.filteredWeather.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KLSMainCell.reuseID, for: indexPath) as! KLSMainCell
        let weather = viewModel.filteredWeather[indexPath.item]
        cell.set(item: weather)
        
        if let activeWeather = viewModel.activeWeather, activeWeather.name == weather.name {
            cell.showProgress(duration: SoundManager.shared.getSoundDuration(soundFileName: weather.soundFileName))
            activeCell = cell
        } else {
            cell.hideProgress()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let soundDuration = viewModel.selectWeather(at: indexPath.item)
        SoundManager.shared.playSound(soundFileName: viewModel.filteredWeather[indexPath.item].soundFileName)
        
        activeCell?.hideProgress()
        if let cell = collectionView.cellForItem(at: indexPath) as? KLSMainCell {
            activeCell = cell
            cell.showProgress(duration: soundDuration)
            DispatchQueue.main.asyncAfter(deadline: .now() + soundDuration) {
                if self.viewModel.activeWeather == self.viewModel.filteredWeather[indexPath.item] {
                    cell.hideProgress()
                    self.activeCell = nil
                    self.viewModel.resetActiveWeather()
                }
            }
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        viewModel.filterWeather(with: searchText)
    }
}

extension KLSWeatherListViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.filterWeather(with: "")
        collectionView.reloadData()
        
        if let activeWeather = viewModel.activeWeather, let activeIndex = viewModel.filteredWeather.firstIndex(where: { $0.name == activeWeather.name }) {
            let indexPath = IndexPath(item: activeIndex, section: 0)
            if let cell = collectionView.cellForItem(at: indexPath) as? KLSMainCell {
                let soundDuration = SoundManager.shared.getSoundDuration(soundFileName: activeWeather.soundFileName)
                cell.showProgress(duration: soundDuration)
                activeCell = cell
                
                DispatchQueue.main.asyncAfter(deadline: .now() + soundDuration) {
                    if self.viewModel.activeWeather == activeWeather {
                        cell.hideProgress()
                        self.activeCell = nil
                        self.viewModel.resetActiveWeather()
                    }
                }
            }
        }
    }
}



//
//  KLSWeatherListViewController.swift
//  Animal Sounds
//
//  Created by Celil Çağatay Gedik on 7.05.2024.
//

import UIKit

final class KLSWeatherListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchResultsUpdating {
    private var collectionView: UICollectionView!
    private let weather = KLSWeatherData.weather.sorted { $0.name < $1.name }
    private var filteredWeather: [KLSMainModel] = []
    private var activeCell: KLSMainCell?
    private var activeWeather: KLSMainModel?
    private var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        addSearchController()
        filteredWeather = weather
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
        return filteredWeather.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KLSMainCell.reuseID, for: indexPath) as! KLSMainCell
        let weather = filteredWeather[indexPath.item]
        cell.set(item: weather)
        
        if let activeWeather = activeWeather, activeWeather.name == weather.name {
            cell.showProgress(duration: SoundManager.shared.getSoundDuration(soundFileName: weather.soundFileName))
            activeCell = cell
        } else {
            cell.hideProgress()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedWeather = filteredWeather[indexPath.item]
        SoundManager.shared.playSound(soundFileName: selectedWeather.soundFileName)
        let soundDuration = SoundManager.shared.getSoundDuration(soundFileName: selectedWeather.soundFileName)
        activeCell?.hideProgress()
        
        if let cell = collectionView.cellForItem(at: indexPath) as? KLSMainCell {
            activeCell = cell
            activeWeather = selectedWeather
            cell.showProgress(duration: soundDuration)
            DispatchQueue.main.asyncAfter(deadline: .now() + soundDuration) {
                if self.activeWeather == selectedWeather {
                    cell.hideProgress()
                    self.activeCell = nil
                    self.activeWeather = nil
                }
            }
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        if searchText.isEmpty {
            filteredWeather = weather
        } else {
            filteredWeather = weather.filter({ $0.name.lowercased().contains(searchText.lowercased()) })
        }
        UIView.transition(with: collectionView, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.collectionView.reloadData()
        }, completion: nil)
    }
}

extension KLSWeatherListViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filteredWeather = weather
        collectionView.reloadData()
        
        if let activeWeather = activeWeather, let activeIndex = weather.firstIndex(where: { $0.name == activeWeather.name }) {
            let indexPath = IndexPath(item: activeIndex, section: 0)
            if let cell = collectionView.cellForItem(at: indexPath) as? KLSMainCell {
                let soundDuration = SoundManager.shared.getSoundDuration(soundFileName: activeWeather.soundFileName)
                cell.showProgress(duration: soundDuration)
                activeCell = cell
                
                DispatchQueue.main.asyncAfter(deadline: .now() + soundDuration) {
                    if self.activeWeather == activeWeather {
                        cell.hideProgress()
                        self.activeCell = nil
                        self.activeWeather = nil
                    }
                }
            }
        }
    }
}


//
//  ViewController.swift
//  Animal Sounds
//
//  Created by Celil Çağatay Gedik on 4.05.2024.
//

import UIKit

final class KLSAnimalListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchResultsUpdating {
    private var collectionView: UICollectionView!
    private let animals = KLSAnimalData.animals.sorted { $0.name < $1.name }
    private var filteredAnimals: [KLSMainModel] = []
    private var activeCell: KLSMainCell?
    private var activeAnimal: KLSMainModel?
    private var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        addSearchController()
        configureCollectionView()
        filteredAnimals = animals
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
        let searchController = setupSearchController(searchBarPlaceholder: "Search for an animal", searchResultsUpdater: self)
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredAnimals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KLSMainCell.reuseID, for: indexPath) as! KLSMainCell
        let animal = filteredAnimals[indexPath.item]
        cell.set(item: animal)
        
        if let activeAnimal = activeAnimal, activeAnimal.name == animal.name {
            cell.showProgress(duration: SoundManager.shared.getSoundDuration(soundFileName: animal.soundFileName))
            activeCell = cell
        } else {
            cell.hideProgress()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedAnimal = filteredAnimals[indexPath.item]
        SoundManager.shared.playSound(soundFileName: selectedAnimal.soundFileName)
        let soundDuration = SoundManager.shared.getSoundDuration(soundFileName: selectedAnimal.soundFileName)
        activeCell?.hideProgress()
        
        if let cell = collectionView.cellForItem(at: indexPath) as? KLSMainCell {
            activeCell = cell
            activeAnimal = selectedAnimal
            cell.showProgress(duration: soundDuration)
            DispatchQueue.main.asyncAfter(deadline: .now() + soundDuration) {
                if self.activeAnimal == selectedAnimal {
                    cell.hideProgress()
                    self.activeCell = nil
                    self.activeAnimal = nil
                }
            }
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        if searchText.isEmpty {
            filteredAnimals = animals
        } else {
            filteredAnimals = animals.filter({ $0.name.lowercased().contains(searchText.lowercased()) })
        }
        UIView.transition(with: collectionView, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.collectionView.reloadData()
        }, completion: nil)
    }
}

extension KLSAnimalListViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filteredAnimals = animals
        collectionView.reloadData()
        
        if let activeAnimal = activeAnimal, let activeIndex = animals.firstIndex(where: { $0.name == activeAnimal.name }) {
            let indexPath = IndexPath(item: activeIndex, section: 0)
            if let cell = collectionView.cellForItem(at: indexPath) as? KLSMainCell {
                let soundDuration = SoundManager.shared.getSoundDuration(soundFileName: activeAnimal.soundFileName)
                cell.showProgress(duration: soundDuration)
                activeCell = cell
                
                DispatchQueue.main.asyncAfter(deadline: .now() + soundDuration) {
                    if self.activeAnimal == activeAnimal {
                        cell.hideProgress()
                        self.activeCell = nil
                        self.activeAnimal = nil
                    }
                }
            }
        }
    }
}

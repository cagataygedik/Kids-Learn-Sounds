//
//  ViewController.swift
//  Animal Sounds
//
//  Created by Celil Çağatay Gedik on 4.05.2024.
//

import UIKit

final class KLSAnimalListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchResultsUpdating {
    private var collectionView: UICollectionView!
    private var viewModel: KLSAnimalListViewModel!
    private var activeCell: KLSMainCell?
    
    private var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        viewModel = KLSAnimalListViewModel(animals: KLSAnimalData.animals)
        configureViewController()
        addSearchController()
        configureCollectionView()
        
        viewModel.onAnimalsUpdated = { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    private func configureViewController() {
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
        collectionView.backgroundColor = Constants.mainBackgroundColor
        collectionView.register(KLSMainCell.self, forCellWithReuseIdentifier: KLSMainCell.reuseID)
    }
    
    private func addSearchController() {
        let searchController = setupSearchController(searchBarPlaceholder: "Search for an animal", searchResultsUpdater: self)
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.filteredAnimals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KLSMainCell.reuseID, for: indexPath) as! KLSMainCell
        let animal = viewModel.filteredAnimals[indexPath.item]
        cell.set(item: animal)
        
        if let activeAnimal = viewModel.activeAnimal, activeAnimal.name == animal.name {
            cell.showProgress(duration: SoundManager.shared.getSoundDuration(soundFileName: animal.soundFileName))
            activeCell = cell
        } else {
            cell.hideProgress()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let soundDuration = viewModel.selectAnimal(at: indexPath.item)
        SoundManager.shared.playSound(soundFileName: viewModel.filteredAnimals[indexPath.item].soundFileName)
        
        activeCell?.hideProgress()
        if let cell = collectionView.cellForItem(at: indexPath) as? KLSMainCell {
            activeCell = cell
            cell.showProgress(duration: soundDuration)
            DispatchQueue.main.asyncAfter(deadline: .now() + soundDuration) {
                if self.viewModel.activeAnimal == self.viewModel.filteredAnimals[indexPath.item] {
                    cell.hideProgress()
                    self.activeCell = nil
                    self.viewModel.resetActiveAnimal()
                }
            }
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        viewModel.filterAnimals(with: searchText)
    }
}

extension KLSAnimalListViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.filterAnimals(with: "")
        collectionView.reloadData()
        
        if let activeAnimal = viewModel.activeAnimal, let activeIndex = viewModel.filteredAnimals.firstIndex(where: { $0.name == activeAnimal.name }) {
            let indexPath = IndexPath(item: activeIndex, section: 0)
            if let cell = collectionView.cellForItem(at: indexPath) as? KLSMainCell {
                let soundDuration = SoundManager.shared.getSoundDuration(soundFileName: activeAnimal.soundFileName)
                cell.showProgress(duration: soundDuration)
                activeCell = cell
                
                DispatchQueue.main.asyncAfter(deadline: .now() + soundDuration) {
                    if self.viewModel.activeAnimal == activeAnimal {
                        cell.hideProgress()
                        self.activeCell = nil
                        self.viewModel.resetActiveAnimal()
                    }
                }
            }
        }
    }
}

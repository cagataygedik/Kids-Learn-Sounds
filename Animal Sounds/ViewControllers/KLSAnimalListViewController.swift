//
//  ViewController.swift
//  Animal Sounds
//
//  Created by Celil Çağatay Gedik on 4.05.2024.
//

import UIKit

final class KLSAnimalListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    private var collectionView: UICollectionView!
    private let animals = KLSAnimalData.animals.sorted { $0.name < $1.name }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
    }
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        let removeAdsButton = UIBarButtonItem(title: "Remove Ads", style: .plain, target: self, action: #selector(removeAdsButtonTapped))
        navigationItem.rightBarButtonItem = removeAdsButton
    }
    
    @objc private func removeAdsButtonTapped() {
        print("test")
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(KLSAnimalCell.self, forCellWithReuseIdentifier: KLSAnimalCell.reuseID)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return animals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KLSAnimalCell.reuseID, for: indexPath) as! KLSAnimalCell
        let animal = animals[indexPath.item]
        cell.set(animal: animal)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedAnimal = animals[indexPath.item]
        SoundManager.shared.playSound(soundFileName: selectedAnimal.soundFileName)
    }
}

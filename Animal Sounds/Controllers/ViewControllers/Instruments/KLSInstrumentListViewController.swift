//
//  FavoritesListViewController.swift
//  Animal Sounds
//
//  Created by Celil Çağatay Gedik on 4.05.2024.
//

import UIKit

final class KLSInstrumentListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    private var collectionView: UICollectionView!
    private let instruments = KLSInstrumentsData.instruments.sorted { $0.name < $1.name }

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
        collectionView.register(KLSMainCell.self, forCellWithReuseIdentifier: KLSMainCell.reuseID)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return instruments.count
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KLSMainCell.reuseID, for: indexPath) as! KLSMainCell
        let instruments = instruments[indexPath.item]
        cell.set(item: instruments)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedInstrument = instruments[indexPath.item]
        SoundManager.shared.playSound(soundFileName: selectedInstrument.soundFileName)
    }
}

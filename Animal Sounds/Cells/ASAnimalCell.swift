//
//  ASAnimalCell.swift
//  Animal Sounds
//
//  Created by Celil Çağatay Gedik on 5.05.2024.
//

import UIKit
import SnapKit

final class ASAnimalCell: UICollectionViewCell {
    static let reuseID = "AnimalCell"
    
    let animalImageView = ASAnimalImageView(frame: .zero)
    let nameLabel = ASNameLabel(textAlignment: .center, fontSize: 16)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(animal: ASAnimal) {
        animalImageView.image = UIImage(named: animal.imageName)
        nameLabel.text = animal.name
    }
    
    private func configure() {
        addSubview(animalImageView)
        addSubview(nameLabel)
        animalImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        animalImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.height.equalTo(animalImageView.snp.width)
            
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(animalImageView.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.height.equalTo(20)
            }
        }
    }
}

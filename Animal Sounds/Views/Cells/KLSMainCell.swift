//
//  ASAnimalCell.swift
//  Animal Sounds
//
//  Created by Celil Çağatay Gedik on 5.05.2024.
//

import UIKit
import SnapKit

final class KLSMainCell: UICollectionViewCell {
    static let reuseID = "MainCell"
    
    let avatarImageView = KLSAvatarImageView(frame: .zero)
    let nameLabel = KLSNameLabel(textAlignment: .center, fontSize: 16)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(animal: KLSMainModel) {
        avatarImageView.image = animal.image
        nameLabel.text = animal.name
    }
    
    private func configure() {
        addSubview(avatarImageView)
        addSubview(nameLabel)
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        avatarImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.height.equalTo(avatarImageView.snp.width)
            
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.height.equalTo(20)
            }
        }
    }
}

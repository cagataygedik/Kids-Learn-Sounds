//
//  ASAnimalImageView.swift
//  Animal Sounds
//
//  Created by Celil Çağatay Gedik on 5.05.2024.
//

import UIKit

final class KLSAvatarImageView: UIImageView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        layer.cornerRadius = 10
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
    }
}

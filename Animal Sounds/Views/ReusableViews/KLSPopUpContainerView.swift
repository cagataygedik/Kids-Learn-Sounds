//
//  KLSAlertContainerView.swift
//  Animal Sounds
//
//  Created by Celil Çağatay Gedik on 9.10.2024.
//

import UIKit

final class KLSPopUpContainerView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        backgroundColor = Constants.mainBackgroundColor
        layer.cornerRadius = 16
        layer.borderWidth = 2
        layer.borderColor = UIColor.white.cgColor
        translatesAutoresizingMaskIntoConstraints = false
    }
}

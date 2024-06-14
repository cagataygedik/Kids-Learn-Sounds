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
    let progressView = KLSCircularProgressView(frame: .zero)
    let darkenAvatarImageView = UIView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(item: KLSMainModel) {
        avatarImageView.image = item.image
        nameLabel.text = item.name
    }
    
    private func configure() {
        addSubview(avatarImageView)
        addSubview(nameLabel)
        avatarImageView.addSubview(darkenAvatarImageView)
        avatarImageView.addSubview(progressView)
        
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        progressView.translatesAutoresizingMaskIntoConstraints = false
        darkenAvatarImageView.translatesAutoresizingMaskIntoConstraints = false
        
        avatarImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.height.equalTo(avatarImageView.snp.width)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.height.equalTo(20)
        }
        
        progressView.snp.makeConstraints { make in
            make.centerX.equalTo(avatarImageView)
            make.centerY.equalTo(avatarImageView)
            make.width.equalTo(avatarImageView.snp.width).multipliedBy(0.8)
            make.height.equalTo(progressView.snp.width)
        }
        progressView.isHidden = true
        
        darkenAvatarImageView.snp.makeConstraints { make in
            make.edges.equalTo(avatarImageView)
        }
        darkenAvatarImageView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        darkenAvatarImageView.isHidden = true
    }
    
    func showProgress(duration: TimeInterval) {
        progressView.isHidden = false
        darkenAvatarImageView.isHidden = false
        progressView.setProgress(0)
        
        let progressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        progressAnimation.toValue = 1
        progressAnimation.duration = duration
        progressAnimation.fillMode = .forwards
        progressAnimation.isRemovedOnCompletion = false
        progressView.progressLayer.add(progressAnimation, forKey: "progressAnim")
    }
    
    func hideProgress() {
        progressView.layer.removeAllAnimations()
        progressView.isHidden = true
        darkenAvatarImageView.isHidden = true
        progressView.setProgress(0)
    }
}

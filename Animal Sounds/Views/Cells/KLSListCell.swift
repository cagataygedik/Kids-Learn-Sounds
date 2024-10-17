//
//  KLSListCollectionViewCell.swift
//  Animal Sounds
//
//  Created by Celil Çağatay Gedik on 4.10.2024.
//

import UIKit
import Kingfisher
import Lottie
import SkeletonView

final class KLSListCell: UICollectionViewCell {
    static let reuseID = "ListCell"
    
    private let avatarImageView = KLSAvatarImageView(frame: .zero)
    private let nameLabel = KLSNameLabel(textAlignment: .center, fontSize: 16)
    
    //Using these with lazy,
    //because they're only requiered only when they called.
    private lazy var progressView: KLSCircularProgressView = {
        let progress = KLSCircularProgressView(frame: .zero)
        progress.isHidden = true
        return progress
    }()
    
    private lazy var darkenAvatarImageView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.isHidden = true
        return view
    }()
    
    var viewModel: KLSListCellViewModel! {
        didSet {
            bindViewModel()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        showSkeletonLoading()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.image = nil
        nameLabel.text = nil
        showSkeletonLoading()
        progressView.setProgress(0)
        progressView.isHidden = true
        darkenAvatarImageView.isHidden = true
    }
    
    private func configure() {
//        isSkeletonable = true //ONUR ABIYE SOR
        avatarImageView.isSkeletonable = true
        nameLabel.isSkeletonable = true
        
        addSubview(avatarImageView)
        addSubview(nameLabel)
        avatarImageView.addSubview(darkenAvatarImageView)
        avatarImageView.addSubview(progressView)
        
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
            make.height.greaterThanOrEqualTo(20)
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
    
    func bindViewModel() {
        showSkeletonLoading()
        
        viewModel.onImageLoad = { [weak self] image in
            self?.avatarImageView.image = image
            self?.hideSkeletonLoading()
            self?.nameLabel.text = self?.viewModel.name
        }
        viewModel.fetchImage()
    }
    
    func showSkeletonLoading() {
        let gradient = SkeletonGradient(baseColor: UIColor.lightGray)
        avatarImageView.showAnimatedGradientSkeleton(usingGradient: gradient)
        nameLabel.showAnimatedGradientSkeleton(usingGradient: gradient)
    }
    
    func hideSkeletonLoading() {
        avatarImageView.hideSkeleton()
        nameLabel.hideSkeleton()
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

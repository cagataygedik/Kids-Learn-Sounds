//
//  KLSAlertViewController.swift
//  Animal Sounds
//
//  Created by Celil Çağatay Gedik on 9.10.2024.
//

import UIKit

final class KLSAlertViewController: UIViewController {
    private let containerView = KLSPopUpContainerView()
    private let titleLabel = KLSNameLabel(textAlignment: .center, fontSize: 20)
    private let errorImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "wifi.slash")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.tintColor = .red
        return image
    }()
    private let messageLabel = KLSNameLabel(textAlignment: .center, fontSize: 16)
    private let retryButton = KLSButton(backgroundColor: Constants.mainAppColor!, title: NSLocalizedString("retry", comment: "Retry Button Title"))
    
    var retryAction: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        configureContainerView()
        configureTitleLabel()
        configureErrorImageView()
        configureRetryButton()
        configureMessageLabel()
    }
    
    init(title: String, message: String) {
        super.init(nibName: nil, bundle: nil)
        self.titleLabel.text = title
        self.messageLabel.text = message
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureContainerView() {
        view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(330)
            make.height.equalTo(260)
        }
    }
    
    private func configureTitleLabel() {
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.top).offset(20)
            make.leading.equalTo(containerView.snp.leading).offset(20)
            make.trailing.equalTo(containerView.snp.trailing).offset(-20)
            make.height.equalTo(28)
        }
    }
    
    private func configureErrorImageView() {
        containerView.addSubview(errorImageView)
        errorImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.centerX.equalTo(containerView.snp.centerX)
            make.width.height.equalTo(60)
        }
    }
    
    private func configureRetryButton() {
        containerView.addSubview(retryButton)
        retryButton.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
        
        retryButton.snp.makeConstraints { make in
            make.bottom.equalTo(containerView.snp.bottom).offset(-20)
            make.leading.equalTo(containerView.snp.leading).offset(20)
            make.trailing.equalTo(containerView.snp.trailing).offset(-20)
            make.height.equalTo(44)
        }
    }
    
    private func configureMessageLabel() {
        containerView.addSubview(messageLabel)
        messageLabel.numberOfLines = 0
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(errorImageView.snp.bottom).offset(8)
            make.leading.equalTo(containerView.snp.leading).offset(20)
            make.trailing.equalTo(containerView.snp.trailing).offset(-20)
            make.bottom.equalTo(retryButton.snp.top).offset(-12)
        }
    }
    
    @objc private func retryButtonTapped() {
        dismiss(animated: true) { [weak self] in
            self?.retryAction?()
        }
    }
}

//
//  KLSFooterLoadingReusableView.swift
//  Animal Sounds
//
//  Created by Celil Çağatay Gedik on 25.10.2024.
//

import UIKit

class KLSFooterLoadingReusableView: UICollectionReusableView {
    static let reuseID = "KLSFooterLoadingReusableView"
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.color = .darkGray
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private let endLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("no_more_items_to_load", comment: "No More Items To Load")
        label.textColor = .gray
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubview(activityIndicator)
        addSubview(endLabel)
        
        activityIndicator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        endLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    func startFooterloading() {
        activityIndicator.startAnimating()
        endLabel.isHidden = true
    }
    
    func stopFooterLoading() {
        activityIndicator.stopAnimating()
        endLabel.isHidden = false
    }
}

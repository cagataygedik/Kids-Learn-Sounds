//
//  KLSListCellViewModel.swift
//  Animal Sounds
//
//  Created by Celil Çağatay Gedik on 4.10.2024.
//

import UIKit
import Kingfisher
import Lottie
import RevenueCat

final class KLSListCellViewModel {
    private let item: KLSModel
    var customerInfo: CustomerInfo?
    private var lastPremiumStatus: Bool?
    
    var onImageLoad: ((UIImage?) -> Void)?
    var onAnimationStart: (() -> Void)?
    var onAnimationStop: (() -> Void)?
    var onPremiumStatus: ((Bool) -> Void)?
    
    init (item: KLSModel, customerInfo: CustomerInfo? = nil) {
        self.item = item
        self.customerInfo = customerInfo
        determinePremiumStatus()
    }
    
    func updateCustomerInfo(_ info: CustomerInfo) {
        self.customerInfo = info
        determinePremiumStatus()
    }
    
    var name: String {
        return item.name
    }
    
    var isItemPremium: Bool {
        return item.isPremium
    }
    
    func fetchImage() {
        if let imagePath = item.image, let imageUrl = URL(string: "https://kids-learn-sounds-api.onrender.com" + imagePath) {
            onAnimationStart?()
            KingfisherManager.shared.retrieveImage(with: imageUrl) { [weak self] result in
                switch result {
                case .success(let value):
                    self?.onImageLoad?(value.image)
                    self?.onAnimationStop?()
                case .failure:
                    self?.onImageLoad?(UIImage(systemName: "questionmark.circle.fill"))
                    self?.onAnimationStop?()
                }
            }
        } else {
            onImageLoad?(UIImage(systemName: "questionmark.circle.fill"))
            onAnimationStop?()
        }
        determinePremiumStatus()
    }
    
    private func determinePremiumStatus() {
        if isItemPremium, let customerInfo = customerInfo, customerInfo.entitlements["premium"]?.isActive == true {
            onPremiumStatus?(false)
        } else if isItemPremium {
            onPremiumStatus?(true)
        } else {
            onPremiumStatus?(false)
        }
    }
}

//
//  KLSListCellViewModel.swift
//  Animal Sounds
//
//  Created by Celil Çağatay Gedik on 4.10.2024.
//

import UIKit
import Kingfisher
import Lottie

final class KLSListCellViewModel {
    private let item: KLSItem
    var onImageLoad: ((UIImage?) -> Void)?
    var onAnimationStart: (() -> Void)?
    var onAnimationStop: (() -> Void)?
    
    init (item: KLSItem) {
        self.item = item
    }
    
    var name: String {
        return item.name
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
    }
}

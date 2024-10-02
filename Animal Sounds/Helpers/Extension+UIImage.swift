//
//  Extension+UIImage.swift
//  Animal Sounds
//
//  Created by Celil Çağatay Gedik on 2.10.2024.
//

import UIKit

extension UIImage {
    func resize(targetSize: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size:targetSize).image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
}

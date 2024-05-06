//
//  Animal.swift
//  Animal Sounds
//
//  Created by Celil Çağatay Gedik on 5.05.2024.
//

import UIKit

struct ASAnimal {
    let name: String
    let image: UIImage
    let soundFileName: String
    
    init(name: String, image: UIImage, soundFileName: String) {
        self.name = name
        self.image = image
        self.soundFileName = soundFileName
    }
}

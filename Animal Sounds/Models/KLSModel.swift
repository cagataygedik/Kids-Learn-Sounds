//
//  KLSItem.swift
//  Animal Sounds
//
//  Created by Celil Çağatay Gedik on 4.10.2024.
//

import Foundation

class KLSModel: Decodable, Hashable {
    let id: Int
    let name: String
    let image: String?
    let sound: String?
    var isPremium: Bool
    
    init(id: Int, name: String, image: String?, sound: String?, isPremium: Bool) {
        self.id = id
        self.name = name
        self.image = image
        self.sound = sound
        self.isPremium = isPremium
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: KLSModel, rhs: KLSModel) -> Bool {
        return lhs.id == rhs.id && lhs.isPremium == rhs.isPremium
    }
}

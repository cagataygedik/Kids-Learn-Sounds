//
//  KLSItem.swift
//  Animal Sounds
//
//  Created by Celil Çağatay Gedik on 4.10.2024.
//

import Foundation

struct KLSModel: Decodable {
    let id: Int
    let name: String
    let image: String?
    let sound: String?
    let isPremium: Bool
}

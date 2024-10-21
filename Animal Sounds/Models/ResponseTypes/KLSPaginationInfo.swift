//
//  KLSPaginationInfo.swift
//  Animal Sounds
//
//  Created by Celil Çağatay Gedik on 21.10.2024.
//

import Foundation

struct KLSPaginationInfo: Decodable {
    let count: Int
    let next: String?
    let pages: Int
    let prev: String?
}

//
//  KLSResponse.swift
//  Animal Sounds
//
//  Created by Celil Çağatay Gedik on 21.10.2024.
//

import Foundation

struct KLSResponse: Decodable {
    let info: KLSPaginationInfo
    let results: [KLSModel]
}

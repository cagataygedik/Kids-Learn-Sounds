//
//  KLSEndpoint.swift
//  Animal Sounds
//
//  Created by Celil Çağatay Gedik on 7.10.2024.
//

import Foundation

enum KLSEndpoint {
    case animals
    case instruments
    case nature
    
    var path: String {
        switch self {
        case .animals: return "animals"
        case .instruments: return "instruments"
        case .nature: return "nature"
        }
    }
}

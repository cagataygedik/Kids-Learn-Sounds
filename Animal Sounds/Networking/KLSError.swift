//
//  KLSError.swift
//  Animal Sounds
//
//  Created by Celil Çağatay Gedik on 9.10.2024.
//

import Foundation

enum KLSError: Error {
    case networkUnavailable
    case invalidURL
    case requestFailed(description: String)
    case decodingFailed
    
    var localizedDescription: String {
        switch self {
        case .networkUnavailable:
            return "We are not process your request at the moment. Please try again later."
        case .invalidURL:
            return "The URL provided was invalid."
        case .requestFailed(let description):
            return "Request failed: \(description)"
        case .decodingFailed:
            return "Failed to decode the response from the server."
        }
    }
}

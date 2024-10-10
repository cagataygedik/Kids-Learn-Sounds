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
            return NSLocalizedString("error_network_unavailable", comment: "Network unavailable error")
        case .invalidURL:
            return NSLocalizedString("error_invalid_url", comment: "Invalid URL error")
        case .requestFailed(let description):
            return String(format: NSLocalizedString("error_request_failed", comment: "Request failed error"), description)
        case .decodingFailed:
            return NSLocalizedString("error_decoding_failed", comment: "Decoding failed error")
        }
    }
}

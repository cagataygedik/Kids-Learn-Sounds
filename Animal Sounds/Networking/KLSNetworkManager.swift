//
//  KLSNetworkManager.swift
//  Animal Sounds
//
//  Created by Celil Çağatay Gedik on 4.10.2024.
//

import Alamofire
import UIKit
import Kingfisher

final class KLSNetworkManager {
    static let shared = KLSNetworkManager()
    private let baseURL = "https://kids-learn-sounds-api.onrender.com"
    
    private init() {}
    
    func getItems(for endpoint: KLSEndpoint, completion: @escaping (Result<[KLSModel], KLSError>) -> Void) {
//        let languageCode = Locale.current.languageCode ?? "en"
//        let url = "\(baseURL)/v1/\(endpoint.path)?lang=\(languageCode)"
        let url = baseURL + "/v1/" + endpoint.path
        AF.request(url).responseDecodable(of: [KLSModel].self) { response in
            switch response.result {
            case .success(let items):
                completion(.success(items))
            case .failure(let error):
                if let afError = error.asAFError, afError.isSessionTaskError {
                    completion(.failure(.networkUnavailable))
                } else {
                    completion(.failure(.requestFailed(description: error.localizedDescription)))
                }
            }
        }
    }
    
    func getImages(from path: String, completion: @escaping (Result<UIImage, KLSError>) -> Void) {
        let fullURL = baseURL + (path.hasPrefix("/") ? path : "/" + path)
        
        guard let url = URL(string: fullURL) else {
            completion(.failure(.invalidURL))
            return
        }
        
        KingfisherManager.shared.retrieveImage(with: url) { result in
            switch result {
            case .success(let imageResult):
                completion(.success(imageResult.image))
            case .failure(let error):
                if (error as NSError).code == NSURLErrorNotConnectedToInternet {
                    completion(.failure(.networkUnavailable))
                } else {
                    completion(.failure(.requestFailed(description: "Failed to load image.")))
                }
            }
        }
    }
}

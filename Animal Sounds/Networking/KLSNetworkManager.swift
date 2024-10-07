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
    private let baseuRL = "https://kids-learn-sounds-api.onrender.com/v1/"
    
    private init() {}
    
    func getItems(for endpoint: KLSEndpoint, completion: @escaping (Result<[KLSModel], Error>) -> Void) {
        let url = baseuRL + endpoint.path
        AF.request(url).responseDecodable(of: [KLSModel].self) { response in
            switch response.result {
             case .success(let items):
                completion(.success(items))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getImages(from path: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        guard let url = URL(string: "https://kids-learn-sounds-api.onrender.com" + path) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
            return
        }
        KingfisherManager.shared.retrieveImage(with: url) { result in
            switch result {
            case .success(let imageResult):
                completion(.success(imageResult.image))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

//
//  KLSNetworkManager.swift
//  Animal Sounds
//
//  Created by Celil Çağatay Gedik on 4.10.2024.
//

import Alamofire

final class KLSNetworkManager {
    static let shared = KLSNetworkManager()
    private let baseuRL = "https://kids-learn-sounds-api.onrender.com/v1/"
    
    private init() {}
    
    func fetchItems(for endpoint: KLSEndpoint, completion: @escaping (Result<[KLSItem], Error>) -> Void) {
        let url = baseuRL + endpoint.path
        AF.request(url).responseDecodable(of: [KLSItem].self) { response in
            switch response.result {
             case .success(let items):
                completion(.success(items))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

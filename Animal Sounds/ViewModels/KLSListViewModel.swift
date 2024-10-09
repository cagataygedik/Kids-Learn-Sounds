//
//  KLSListViewModel.swift
//  Animal Sounds
//
//  Created by Celil Çağatay Gedik on 4.10.2024.
//

import Foundation

final class KLSListViewModel {
    private(set) var items: [KLSModel] = []
    private(set) var filteredItems: [KLSModel] = []
    
    var onItemsUpdated: (() -> Void)?
    var showError: ((KLSError, KLSEndpoint) -> Void)?
    
    func fetchItems(for endpoint: KLSEndpoint) {
        KLSNetworkManager.shared.getItems(for: endpoint) { [weak self] result in
            switch result {
            case .success(let items):
                self?.items = items
                self?.filteredItems = self?.items ?? []
                self?.onItemsUpdated?()
            case .failure(let error):
                self?.showError?(error, endpoint)
            }
        }
    }
    
    func filterItems(with searchText: String) {
        if searchText.isEmpty {
            filteredItems = items
        } else {
            filteredItems = items.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        onItemsUpdated?()
    }
}

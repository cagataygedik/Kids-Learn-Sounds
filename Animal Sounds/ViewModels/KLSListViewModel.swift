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
    private var searchWorkItem: DispatchWorkItem?
    
    var onItemsUpdated: (() -> Void)?
    var showError: ((KLSError, KLSEndpoint) -> Void)?
    
    var activeItemId: Int?
    
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
        searchWorkItem?.cancel()
        let newWorkItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.filteredItems = searchText.isEmpty
            ? self.items
            : self.items.filter { $0.name.lowercased().contains(searchText.lowercased()) }
            
            if let activeItemId = self.activeItemId,
               !self.filteredItems.contains(where: { $0.id == activeItemId}) {
                self.activeItemId = nil
            }
            self.onItemsUpdated?()
        }
        searchWorkItem = newWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: newWorkItem)
    }
}

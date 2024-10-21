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
    private var currentPage: Int = 1
    private var totalPages: Int = 1
    private var isLoading: Bool = false
    
    var onItemsUpdated: ((_ newItemsCount: Int) -> Void)?
    var showError: ((KLSError, KLSEndpoint) -> Void)?
    
    var activeItemId: Int?
    
    func fetchItems(for endpoint: KLSEndpoint, page: Int = 1, isPagination: Bool = false) {
        guard !isLoading else { return }
        isLoading = true
        
        KLSNetworkManager.shared.getItems(for: endpoint, page: page) { [weak self] result in
            switch result {
            case .success(let paginatedResponse):
                let newItems: [KLSModel]
                
                if isPagination {
                    newItems = paginatedResponse.results
                    self?.items.append(contentsOf: newItems)
                } else {
                    self?.items = paginatedResponse.results
                    newItems = self?.items ?? []
                }
                
                self?.filteredItems = self?.items ?? [] // Always ensure filteredItems is not nil
                self?.currentPage = page
                self?.totalPages = paginatedResponse.info.pages
                
                // Notify new item count
                self?.onItemsUpdated?(newItems.count)
            case .failure(let error):
                self?.showError?(error, endpoint)
            }
            self?.isLoading = false
        }
    }
    
    func loadMoreItems(for endpoint: KLSEndpoint) {
        guard currentPage < totalPages else { return }
        fetchItems(for: endpoint, page: currentPage + 1, isPagination: true)
    }
    
    func filterItems(with searchText: String) {
        searchWorkItem?.cancel()
        let newWorkItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.filteredItems = searchText.isEmpty
            ? self.items
            : self.items.filter { $0.name.lowercased().contains(searchText.lowercased()) }
            
//            self.filteredItems.sort { $0.name.lowercased() < $1.name.lowercased() }
            
            if let activeItemId = self.activeItemId,
               !self.filteredItems.contains(where: { $0.id == activeItemId}) {
                self.activeItemId = nil
            }
            self.onItemsUpdated?(self.filteredItems.count)
        }
        searchWorkItem = newWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: newWorkItem)
    }
}

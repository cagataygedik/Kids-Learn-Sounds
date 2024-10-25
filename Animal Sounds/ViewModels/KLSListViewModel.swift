//
//  KLSListViewModel.swift
//  Animal Sounds
//
//  Created by Celil Çağatay Gedik on 4.10.2024.
//

import Foundation
import RevenueCat

final class KLSListViewModel {
    private(set) var items: [KLSModel] = []
    private(set) var filteredItems: [KLSModel] = []
    private(set) var isLoadingMore = false
    private(set) var hasReachedEnd = false
    
    private var searchWorkItem: DispatchWorkItem?
    private var currentPage: Int = 1
    private var totalPages: Int = 1
    var isLoading: Bool = false
    
    var hasMorePages: Bool { return !hasReachedEnd && currentPage < totalPages }
    
    var onItemsUpdated: ((_ newItemsCount: Int) -> Void)?
    var showError: ((KLSError, KLSEndpoint) -> Void)?
    
    var activeItemId: Int?
    
    var customerInfo: CustomerInfo?
    
    init() {
        fetchInitialCustomerInfo()
    }
    
    private func fetchInitialCustomerInfo() {
        Purchases.shared.getCustomerInfo { [weak self] (customerInfo, error) in
            guard let self = self else { return }
            if let info = customerInfo, error == nil {
                self.updateCustomerInfo(info)
            } else {
                print("Failed to fetch initial customer info: \(error?.localizedDescription ?? "No error")")
            }
        }
    }
    
    func updateCustomerInfo(_ info: CustomerInfo) {
        self.customerInfo = info
        onItemsUpdated?(filteredItems.count)
    }
    
    func fetchItems(for endpoint: KLSEndpoint, page: Int = 1, isPagination: Bool = false) {
        guard !isLoading else { return }
        
        isLoading = true
        
        KLSNetworkManager.shared.getItems(for: endpoint, page: page) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let paginatedResponse):
                let newItems = paginatedResponse.results
                
                if isPagination {
                    if newItems.isEmpty {
                        self.hasReachedEnd = true
                    } else {
                        self.items.append(contentsOf: newItems)
                    }
                } else {
                    self.items = newItems
                    self.hasReachedEnd = newItems.isEmpty
                }
                
                self.filteredItems = self.items
                self.currentPage = page
                self.totalPages = paginatedResponse.info.pages
                
                self.hasReachedEnd = paginatedResponse.info.next == nil
                
                self.onItemsUpdated?(newItems.count)
                
                
                
            case .failure(let error):
                self.showError?(error, endpoint)
                self.hasReachedEnd = true
            }
            
            self.isLoading = false
            self.isLoadingMore = false
        }
    }
    
    func loadMoreItems(for endpoint: KLSEndpoint) {
        guard !isLoading && !isLoadingMore && hasMorePages else { return }
        
        isLoadingMore = true
        fetchItems(for: endpoint, page: currentPage + 1, isPagination: true)
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
            self.onItemsUpdated?(self.filteredItems.count)
        }
        searchWorkItem = newWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: newWorkItem)
    }
}

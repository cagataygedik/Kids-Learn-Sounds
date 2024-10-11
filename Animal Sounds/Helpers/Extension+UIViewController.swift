//
//  Extension+UISearchController.swift
//  Animal Sounds
//
//  Created by Celil Çağatay Gedik on 10.05.2024.
//

import UIKit
import RevenueCat
import RevenueCatUI

extension UIViewController {
    func setupSearchController(searchBarPlaceholder: String, searchResultsUpdater: UISearchResultsUpdating) -> UISearchController {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = searchResultsUpdater
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = searchBarPlaceholder
        return searchController
    }
}

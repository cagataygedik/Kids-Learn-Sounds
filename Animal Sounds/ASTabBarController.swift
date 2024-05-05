//
//  ASTabBarController.swift
//  Animal Sounds
//
//  Created by Celil Çağatay Gedik on 4.05.2024.
//

import UIKit

final class ASTabBarController: UITabBarController {

    override func viewDidLoad() {
            super.viewDidLoad()
            configureTabBar()
        }
        
        func configureTabBar() {
            UITabBar.appearance().tintColor = .systemGreen
            UINavigationBar.appearance().tintColor = .systemGreen
            viewControllers = [createAnimalListController(), createFavoritesListNavigationController()]
        }
        
        func createAnimalListController() -> UINavigationController {
            let animalsListViewController = ASAnimalListViewController()
            animalsListViewController.title = "Animals"
            let tabBarItem = UITabBarItem(title: "Animals", image: UIImage(systemName: "pawprint.fill"), tag: 0)
            animalsListViewController.tabBarItem = tabBarItem
            
            return UINavigationController(rootViewController: animalsListViewController)
        }
        
        func createFavoritesListNavigationController() -> UINavigationController {
            let favoritesListViewController = ASFavoritesListViewController()
            favoritesListViewController.title = "Favorites"
            favoritesListViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
            
            return UINavigationController(rootViewController: favoritesListViewController)
        }
    }

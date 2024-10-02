//
//  ASTabBarController.swift
//  Animal Sounds
//
//  Created by Celil Çağatay Gedik on 4.05.2024.
//

import UIKit

/*
final class OldTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
    }
    
    func configureTabBar() {
        UITabBar.appearance().tintColor = .systemCyan
        UINavigationBar.appearance().tintColor = .systemCyan
        viewControllers = [createAnimalListController(), createInstrumentsListNavigationController(), createWeatherListNavigationController()]
    }
    
    func createAnimalListController() -> UINavigationController {
        let animalsListViewController = KLSAnimalListViewController()
        animalsListViewController.title = "Animals"
        let tabBarItem = UITabBarItem(title: "Animals", image: UIImage(systemName: "pawprint.fill"), tag: 0)
        animalsListViewController.tabBarItem = tabBarItem
        
        return UINavigationController(rootViewController: animalsListViewController)
    }
    
    func createInstrumentsListNavigationController() -> UINavigationController {
        let instrumentsListViewController = KLSInstrumentListViewController()
        instrumentsListViewController.title = "Instruments"
        let tabBarItem = UITabBarItem(title: "Instruments", image: UIImage(systemName: "music.note"), tag: 1)
        instrumentsListViewController.tabBarItem = tabBarItem
        
        return UINavigationController(rootViewController: instrumentsListViewController)
    }
    
    func createWeatherListNavigationController() -> UINavigationController {
        let weatherListViewController = KLSWeatherListViewController()
        weatherListViewController.title = "Weather"
        let tabBarItem = UITabBarItem(title: "Weather", image: UIImage(systemName: "cloud.sun.fill"), tag: 2)
        weatherListViewController.tabBarItem = tabBarItem
        
        return UINavigationController(rootViewController: weatherListViewController)
    }
    
 }*/

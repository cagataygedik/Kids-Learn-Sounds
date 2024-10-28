//
//  KLSTabBarController.swift
//  Animal Sounds
//
//  Created by Celil Çağatay Gedik on 2.10.2024.
//

import UIKit
import RevenueCat
import RevenueCatUI

final class KLSTabBarController: UITabBarController {
    let tabbarView = UIView()
    var buttons: [UIButton] = []
    let tabbarItemBackgroundView = UIView()
    var centerConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.isHidden = true
        setView()
        setInitialTabState()
    }
    
    /*
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkAndShowPaywallIfNeeded()
    }
     */
    
    private func setView() {
        view.addSubview(tabbarView)
        tabbarView.backgroundColor = Constants.tabBarBackgroundColor
        tabbarView.translatesAutoresizingMaskIntoConstraints = false
        tabbarView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60).isActive = true
        tabbarView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -60).isActive = true
        tabbarView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        tabbarView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tabbarView.layer.cornerRadius = 30
        
        generateControllers()
        
        for x in 0..<buttons.count {
            tabbarView.addSubview(buttons[x])
            buttons[x].tag = x
            buttons[x].centerYAnchor.constraint(equalTo: tabbarView.centerYAnchor).isActive = true
            buttons[x].widthAnchor.constraint(equalTo: tabbarView.widthAnchor, multiplier: 1/CGFloat(buttons.count)).isActive = true
            buttons[x].heightAnchor.constraint(equalTo: tabbarView.heightAnchor).isActive = true
            buttons[x].addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
            
            if x == 0 {
                buttons[x].leftAnchor.constraint(equalTo: tabbarView.leftAnchor).isActive = true
            } else {
                buttons[x].leftAnchor.constraint(equalTo: buttons[x-1].rightAnchor).isActive = true
            }
        }
        
        tabbarView.addSubview(tabbarItemBackgroundView)
        tabbarItemBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        tabbarItemBackgroundView.widthAnchor.constraint(equalTo: tabbarView.widthAnchor, multiplier: 1/CGFloat(buttons.count), constant: -10).isActive = true
        tabbarItemBackgroundView.heightAnchor.constraint(equalTo: tabbarView.heightAnchor, constant: -10).isActive = true
        tabbarItemBackgroundView.centerYAnchor.constraint(equalTo: tabbarView.centerYAnchor).isActive = true
        tabbarItemBackgroundView.layer.cornerRadius = 25
        tabbarItemBackgroundView.backgroundColor = Constants.tabBarSelectedBackgroundColor
        
        centerConstraint = tabbarItemBackgroundView.centerXAnchor.constraint(equalTo: buttons[0].centerXAnchor)
        centerConstraint?.isActive = true
    }
    
    @objc private func buttonTapped(sender: UIButton) {
        selectedIndex = sender.tag
        
        for button in buttons {
            button.tintColor = .systemGray2
        }
        
        tabbarView.bringSubviewToFront(sender)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .beginFromCurrentState) {
            self.centerConstraint?.isActive = false
            self.centerConstraint = self.tabbarItemBackgroundView.centerXAnchor.constraint(equalTo: self.buttons[sender.tag].centerXAnchor)
            self.centerConstraint?.isActive = true
            self.buttons[sender.tag].tintColor = .black
            self.tabbarView.layoutIfNeeded()
        }
    }
    
    private func setInitialTabState() {
        buttons[0].tintColor = .black
        
        tabbarView.bringSubviewToFront(buttons[0])
        self.centerConstraint?.isActive = false
        self.centerConstraint = self.tabbarItemBackgroundView.centerXAnchor.constraint(equalTo: self.buttons[0].centerXAnchor)
        self.centerConstraint?.isActive = true
        self.tabbarView.layoutIfNeeded()
    }
    
    private func generateControllers() {
        let animals = generateViewControllers(image: UIImage(systemName: "pawprint.fill")!, viewController: KLSListViewController(endpoint: .animals), title: NSLocalizedString("animals", comment: "Animals Tab Title"))
        let instruments = generateViewControllers(image: UIImage(systemName: "music.note")!, viewController: KLSListViewController(endpoint: .instruments), title: NSLocalizedString("instruments", comment: "Instruments Tab Title"))
        let nature = generateViewControllers(image: UIImage(systemName: "cloud.sun.fill")!, viewController: KLSListViewController(endpoint: .nature), title: NSLocalizedString("nature", comment: "Nature Tab Title"))
        let settings = generateViewControllers(image: UIImage(systemName: "gear")!, viewController: KLSSettingsViewController(), title: NSLocalizedString("settings", comment: "Setting Tab Title"))
        viewControllers = [animals, instruments, nature, settings]
    }
    
    private func generateViewControllers(image: UIImage, viewController: UIViewController, title: String) -> UIViewController {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .systemGray2
        let resizedImage = image.resize(targetSize: CGSize(width: 25, height: 25)).withRenderingMode(.alwaysTemplate)
        button.setImage(resizedImage, for: .normal)
        buttons.append(button)
        viewController.title = title
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem = UITabBarItem(title: title, image: resizedImage, tag: buttons.count - 1)
        
        return navigationController
    }
}

//
//  KLSSettingsViewController.swift
//  Animal Sounds
//
//  Created by Celil Çağatay Gedik on 13.05.2024.
//

import SnapKit
import StoreKit
import SafariServices
import SwiftUI
import UIKit

final class KLSSettingsViewController: UIViewController {
    
    private var settingsSwiftUIController: UIHostingController<KLSSettingsView>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.mainBackgroundColor
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Settings"
        addSwiftUIController()
    }
    
    private func addSwiftUIController() {
        let settingsSwiftUIController = UIHostingController(
            rootView: KLSSettingsView(
                viewModel: KLSSettingsViewModel(
                    cellViewModels: KLSSettingsOption.allCases.compactMap({
                        return KLSSettingsCellViewModel(type: $0) { [weak self] option in
                            self?.handleTap(option: option)
                        }
                    })
                )
            )
        )
        addChild(settingsSwiftUIController)
        settingsSwiftUIController.didMove(toParent: self)
        
        view.addSubview(settingsSwiftUIController.view)
        settingsSwiftUIController.view.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        self.settingsSwiftUIController = settingsSwiftUIController
    }
    
    private func handleTap(option: KLSSettingsOption) {
        guard Thread.current.isMainThread else {
            return
        }
        
        if let url = option.twitterTargetUrl {
            let twitterUrl = Constants.twitterUrl
            if UIApplication.shared.canOpenURL(twitterUrl!) {
                UIApplication.shared.open(twitterUrl!, options: [:], completionHandler: nil)
                return
            }
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true)
            
        } else if let url = option.rateAppTargetUrl {
            let rateAppUrl = Constants.rateAppUrl
            if UIApplication.shared.canOpenURL(rateAppUrl!) {
                UIApplication.shared.open(rateAppUrl!, options: [:], completionHandler: nil)
                return
            }
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true)
            
        } else if option == .developer {
            let alert = UIAlertController(title: "Made in 🇹🇷", message: "by Celil Cagatay Gedik", preferredStyle: .alert)
            alert.view.tintColor = .cyan
            let perfectButton = UIAlertAction(title: "God Bless Him", style: .default, handler: nil)
            alert.addAction(perfectButton)
            present(alert, animated: true, completion: nil)
            
        } else if let url = option.privacyPolicyTargetUrl {
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true)
        }
    }
}

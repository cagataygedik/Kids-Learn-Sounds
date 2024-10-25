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
    
    func checkAndShowPaywallIfNeeded() {
        Purchases.shared.getCustomerInfo { [weak self] (customerInfo, error) in
            guard error == nil else {
                print("Failed to fetch customer info: \(error?.localizedDescription ?? "")")
                return
            }
            
            if let customerInfo = customerInfo, customerInfo.entitlements["premium"]?.isActive == true {
                print("User already has the premium entitlement")
                print(Purchases.shared.appUserID)
            } else {
                self?.presentPaywall()
            }
        }
    }
    
    func presentPaywall() {
        let paywall = RevenueCatUI.PaywallViewController()
        self.present(paywall, animated: true, completion: nil)
    }
}

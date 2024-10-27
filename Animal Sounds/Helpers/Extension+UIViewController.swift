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
        // Present the parental gate before showing the paywall
        presentParentalGate { [weak self] success in
            if success {
                let paywall = RevenueCatUI.PaywallViewController()
                self?.present(paywall, animated: true, completion: nil)
            } else {
                // Optionally handle parental gate failure (e.g., show an alert)
                self?.showParentalGateFailedAlert()
            }
        }
    }
    
    func presentParentalGate(completion: @escaping (Bool) -> Void) {
        let parentalGateVC = KLSParentalGateViewController()
        parentalGateVC.modalPresentationStyle = .overFullScreen
        parentalGateVC.onGateSuccess = {
            // Call the completion block if parental gate is passed
            completion(true)
        }
        
        self.present(parentalGateVC, animated: true, completion: nil)
    }
    
    private func showParentalGateFailedAlert() {
            let alert = UIAlertController(title: "Access Denied", message: "You must pass the parental gate to proceed.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
}

//
//  KLSSettingsOption.swift
//  Animal Sounds
//
//  Created by Celil Çağatay Gedik on 13.05.2024.
//

import UIKit

enum KLSSettingsOption: CaseIterable {
    case rateApp
    case contactUs
    case developer
    case privacyPolicy
    
    var twitterTargetUrl: URL? {
        switch self {
        case .rateApp:
            return nil
        case .contactUs:
           return Constants.twitterUrl
        case .developer:
            return nil
        case .privacyPolicy:
            return nil
        }
    }
    
    var privacyPolicyTargetUrl: URL? {
        switch self {
        case .rateApp:
            return nil
        case .contactUs:
            return nil
        case .developer:
            return nil
        case .privacyPolicy:
            return Constants.privacyPolicyUrl
        }
    }
    
    var rateAppTargetUrl: URL? {
        switch self {
        case .rateApp:
            return Constants.rateAppUrl
        case .contactUs:
            return nil
        case .developer:
            return nil
        case .privacyPolicy:
            return nil
        }
    }
    
    var displayTitle: String {
        switch self {
        case .rateApp:
            return NSLocalizedString("rate_app", comment: "Rate App cell")
        case .contactUs:
            return NSLocalizedString("contact_developer", comment: "Contact Developer ce;;")
        case .developer:
            return NSLocalizedString("developer", comment: "Developer cell")
        case .privacyPolicy:
            return NSLocalizedString("privacy_policy", comment: "Privacy Policy cell")
        }
    }
    
    var iconImage: UIImage? {
        switch self {
        case .rateApp:
            return UIImage(systemName: "star")
        case .contactUs:
            return UIImage(systemName: "paperplane")
        case .developer:
            return UIImage(systemName: "hammer")
        case .privacyPolicy:
            return UIImage(systemName: "doc.text")
        }
    }
    
    var iconContainerColor: UIColor {
        switch self {
        case .rateApp:
            return Constants.mainAppColor!
        case .contactUs:
            return Constants.mainAppColor!
        case .developer:
            return Constants.mainAppColor!
        case .privacyPolicy:
            return Constants.mainAppColor!
        }
    }
}

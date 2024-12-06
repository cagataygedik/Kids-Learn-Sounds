//
//  KLSSettingsOption.swift
//  Animal Sounds
//
//  Created by Celil Çağatay Gedik on 13.05.2024.
//

import UIKit

enum KLSSettingsOption: CaseIterable {
    case rateApp
    case developer
    case privacyPolicy
    case termsOfUse
    
    var privacyPolicyTargetUrl: URL? {
        switch self {
        case .rateApp:
            return nil
        case .developer:
            return nil
        case .privacyPolicy:
            return Constants.privacyPolicyUrl
        case .termsOfUse:
            return nil
        }
    }
    
    var rateAppTargetUrl: URL? {
        switch self {
        case .rateApp:
            return Constants.rateAppUrl
        case .developer:
            return nil
        case .privacyPolicy:
            return nil
        case .termsOfUse:
            return nil
        }
    }
    
    var termsOfUseTargetUrl: URL? {
        switch self {
        case .rateApp:
            return nil
        case .developer:
            return nil
        case .privacyPolicy:
            return nil
        case .termsOfUse:
            return Constants.termsOfUseUrl
        }
    }
    
    var displayTitle: String {
        switch self {
        case .rateApp:
            return NSLocalizedString("rate_app", comment: "Rate App cell")
        case .developer:
            return NSLocalizedString("developer", comment: "Developer cell")
        case .privacyPolicy:
            return NSLocalizedString("privacy_policy", comment: "Privacy Policy cell")
        case .termsOfUse:
            return NSLocalizedString("terms_of_use", comment: "Terms of Use cell")
        }
    }
    
    var iconImage: UIImage? {
        switch self {
        case .rateApp:
            return UIImage(systemName: "star")
        case .developer:
            return UIImage(systemName: "hammer")
        case .privacyPolicy:
            return UIImage(systemName: "hand.raised")
        case .termsOfUse:
            return UIImage(systemName: "doc.text")
        }
    }
    
    var iconContainerColor: UIColor {
        switch self {
        case .rateApp:
            return Constants.mainAppColor!
        case .developer:
            return Constants.mainAppColor!
        case .privacyPolicy:
            return Constants.mainAppColor!
        case .termsOfUse:
            return Constants.mainAppColor!
        }
    }
}

//
//  KLSSettingsCellViewModel.swift
//  Animal Sounds
//
//  Created by Celil Çağatay Gedik on 13.05.2024.
//

import UIKit

struct KLSSettingsCellViewModel: Identifiable {
    let id = UUID()
    
    public let type: KLSSettingsOption
    public let onTapHandler: (KLSSettingsOption) -> Void
    
    init(type: KLSSettingsOption, onTapHandler: @escaping (KLSSettingsOption) -> Void) {
        self.type = type
        self.onTapHandler = onTapHandler
    }
    
    public var image: UIImage? { return type.iconImage }
    
    public var title: String { return type.displayTitle }
    
    public var iconContainerColor: UIColor { return type.iconContainerColor }
}

//
//  KLSWeatherData.swift
//  Animal Sounds
//
//  Created by Celil Çağatay Gedik on 8.05.2024.
//

import UIKit

struct KLSWeatherData {
    static let weather: [KLSMainModel] = [
        KLSMainModel(name: "Fire", image: UIImage(named: "fire") ?? UIImage(), soundFileName: "fire"),
        KLSMainModel(name: "Forest", image: UIImage(named: "forest") ?? UIImage(), soundFileName: "forest"),
        KLSMainModel(name: "Lightning", image: UIImage(named: "lightning") ?? UIImage(), soundFileName: "lightning"),
        KLSMainModel(name: "Rain", image: UIImage(named: "rain") ?? UIImage(), soundFileName: "rain"),
        KLSMainModel(name: "Wind", image: UIImage(named: "wind") ?? UIImage(), soundFileName: "wind"),
    ]
}

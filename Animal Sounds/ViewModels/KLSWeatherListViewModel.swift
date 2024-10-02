//
//  KLSWeatherListViewModel.swift
//  Animal Sounds
//
//  Created by Celil Çağatay Gedik on 2.10.2024.
//

import Foundation

final class KLSWeatherListViewModel {
    private let weather: [KLSMainModel]
    private(set) var filteredWeather: [KLSMainModel] = []
    
    var activeWeather: KLSMainModel?
    var onWeatherUpdated: (() -> Void)?
    
    init(weather: [KLSMainModel]) {
        self.weather = weather.sorted { $0.name < $1.name }
        self.filteredWeather = self.weather
    }
    
    func filterWeather(with searchText: String) {
        if searchText.isEmpty {
            filteredWeather = weather
        } else {
            filteredWeather = weather.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        onWeatherUpdated?()
    }
    
    func selectWeather(at index: Int) -> TimeInterval {
        let selectedWeather = filteredWeather[index]
        activeWeather = selectedWeather
        return SoundManager.shared.getSoundDuration(soundFileName: selectedWeather.soundFileName)
    }
    
    func resetActiveWeather() {
        activeWeather = nil
    }
}


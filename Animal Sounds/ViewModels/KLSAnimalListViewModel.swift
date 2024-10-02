//
//  KLSAnimalListViewModel.swift
//  Animal Sounds
//
//  Created by Celil Çağatay Gedik on 2.10.2024.
//

import Foundation

final class KLSAnimalListViewModel {
    private let animals: [KLSMainModel]
    private(set) var filteredAnimals: [KLSMainModel] = []
    
    var activeAnimal: KLSMainModel?
    var onAnimalsUpdated: (() -> Void)?
    
    init(animals: [KLSMainModel]) {
        self.animals = animals.sorted { $0.name < $1.name }
        self.filteredAnimals = self.animals
    }
    
    func filterAnimals(with searchText: String) {
        if searchText.isEmpty {
            filteredAnimals = animals
        } else {
            filteredAnimals = animals.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        onAnimalsUpdated?()
    }
    
    func selectAnimal(at index: Int) -> TimeInterval {
        let selectedAnimal = filteredAnimals[index]
        activeAnimal = selectedAnimal
        return SoundManager.shared.getSoundDuration(soundFileName: selectedAnimal.soundFileName)
    }
    
    func resetActiveAnimal() {
        activeAnimal = nil
    }
}

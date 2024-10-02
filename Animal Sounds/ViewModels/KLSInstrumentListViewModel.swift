//
//  KLSInstrumentListViewModel.swift
//  Animal Sounds
//
//  Created by Celil Çağatay Gedik on 2.10.2024.
//

import Foundation

final class KLSInstrumentListViewModel {
    private let instruments: [KLSMainModel]
    private(set) var filteredInstruments: [KLSMainModel] = []
    
    var activeInstrument: KLSMainModel?
    var onInstrumentsUpdated: (() -> Void)?
    
    init(instruments: [KLSMainModel]) {
        self.instruments = instruments.sorted { $0.name < $1.name }
        self.filteredInstruments = self.instruments
    }
    
    func filterInstruments(with searchText: String) {
        if searchText.isEmpty {
            filteredInstruments = instruments
        } else {
            filteredInstruments = instruments.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        onInstrumentsUpdated?()
    }
    
    func selectInstrument(at index: Int) -> TimeInterval {
        let selectedInstrument = filteredInstruments[index]
        activeInstrument = selectedInstrument
        return SoundManager.shared.getSoundDuration(soundFileName: selectedInstrument.soundFileName)
    }
    
    func resetActiveInstrument() {
        activeInstrument = nil
    }
}


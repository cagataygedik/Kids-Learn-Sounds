//
//  InstrumentsData.swift
//  Animal Sounds
//
//  Created by Celil Çağatay Gedik on 8.05.2024.
//

import UIKit

struct KLSInstrumentsData {
    static let instruments: [KLSMainModel] = [
        KLSMainModel(name: "Accordion", image: UIImage(named: "accordion") ?? UIImage(), soundFileName: "accordion"),
        KLSMainModel(name: "Baglama", image: UIImage(named: "baglama") ?? UIImage(), soundFileName: ""),
        KLSMainModel(name: "Bagpipe", image: UIImage(named: "bagpipe") ?? UIImage(), soundFileName: "bagpipe"),
        KLSMainModel(name: "Cello", image: UIImage(named: "cello") ?? UIImage(), soundFileName: "chicken"),
        KLSMainModel(name: "Clarinet", image: UIImage(named: "clarinet") ?? UIImage(), soundFileName: ""),
        KLSMainModel(name: "Conga", image: UIImage(named: "conga") ?? UIImage(), soundFileName: "conga"),
        KLSMainModel(name: "Drum", image: UIImage(named: "drum") ?? UIImage(),soundFileName: ""),
        KLSMainModel(name: "Flute", image: UIImage(named: "flute") ?? UIImage(), soundFileName: "flute"),
        KLSMainModel(name: "French-horn", image: UIImage(named: "french-horn") ?? UIImage(), soundFileName: "french-horn"),
        KLSMainModel(name: "Gong", image: UIImage(named: "gong") ?? UIImage(), soundFileName: "hippo"),
        KLSMainModel(name: "Guitar", image: UIImage(named: "guitar") ?? UIImage(), soundFileName: "guitar"),
        KLSMainModel(name: "Maracas", image: UIImage(named: "maracas") ?? UIImage(), soundFileName: "maracas"),
        KLSMainModel(name: "Piano", image: UIImage(named: "piano") ?? UIImage(), soundFileName: "piano"),
        KLSMainModel(name: "Saxophone", image: UIImage(named: "saxophone") ?? UIImage(), soundFileName: "saxophone"),
        KLSMainModel(name: "Trumpet", image: UIImage(named: "trumpet") ?? UIImage(), soundFileName: "trumpet"),
        KLSMainModel(name: "Zampona", image: UIImage(named: "zampona") ?? UIImage(), soundFileName: "zampona"),
    ]
}


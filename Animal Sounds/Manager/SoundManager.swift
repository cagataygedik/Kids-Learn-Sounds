//
//  SoundManager.swift
//  Animal Sounds
//
//  Created by Celil Çağatay Gedik on 7.05.2024.
//

import AVFoundation

class SoundManager {
    static let shared = SoundManager()
    private var audioPlayer: AVAudioPlayer?
    
    private init() {}
    
    func playSound(soundFileName: String) {
        guard let soundURL = Bundle.main.url(forResource: soundFileName, withExtension: "mp3") else {
            print("test")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("catch error")
        }
    }
    
    func getSoundDuration(soundFileName: String) -> TimeInterval {
        guard let soundURL = Bundle.main.url(forResource: soundFileName, withExtension: "mp3") else {
            print("Error")
            return 0
        }
        do {
            let audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            return audioPlayer.duration
        } catch {
            print("could not get sound duration")
            return 0
        }
    }
}

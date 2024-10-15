//
//  SoundManagerTest.swift
//  Animal Sounds
//
//  Created by Celil Çağatay Gedik on 4.10.2024.
//

import AVFoundation

final class SoundManager {
    static let shared = SoundManager()
    
    private var player: AVPlayer?
    private var startTime: Date?
    
    private init() {}
    
    func playSound(from soundPath: String?) {
        guard let soundPath = soundPath,
              let url = URL(string: "https://kids-learn-sounds-api.onrender.com" + soundPath) else {
            print("Invalid sound URL or soundPath is nil")
            return
        }
        player = AVPlayer(url: url)
        player?.play()
    }
    
    func stopSound() {
        player?.pause()
    }
    
    func getSoundDuration(from soundPath: String?) -> TimeInterval {
        guard let soundPath = soundPath,
              let url = URL(string: "https://kids-learn-sounds-api.onrender.com" + soundPath) else {
            return 0
        }
        let asset = AVURLAsset(url: url)
        return CMTimeGetSeconds(asset.duration)
    }
}

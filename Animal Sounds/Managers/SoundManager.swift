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
    private var activeSoundId: Int?
    private var startTime: Date?
    
    private init() {}
    
    func playSound(for id: Int, from soundPath: String?) {
        guard let soundPath = soundPath,
              let url = URL(string: "https://kids-learn-sounds-api.onrender.com" + soundPath) else {
            print("Invalid sound URL or soundPath is nil")
            return
        }
        
        stopSound()
        player = AVPlayer(url: url)
        player?.play()
        activeSoundId = id
        startTime = Date()
    }
    
    func stopSound() {
        player?.pause()
        player = nil
        activeSoundId = nil
        startTime = nil
    }
    
    func getSoundDuration(from soundPath: String?) -> TimeInterval {
        guard let soundPath = soundPath,
              let url = URL(string: "https://kids-learn-sounds-api.onrender.com" + soundPath) else {
            return 0
        }
        let asset = AVURLAsset(url: url)
        return CMTimeGetSeconds(asset.duration)
    }
    
    func getActiveSoundId() -> Int? {
        return activeSoundId
    }
    
    func getElapsedTime() -> TimeInterval {
        guard let startTime = startTime else { return 0 }
        return Date().timeIntervalSince(startTime)
    }
    
    func getRemainingTime(for id: Int, from soundPath: String?) -> TimeInterval {
        guard id == activeSoundId, let startTime = startTime else { return 0 }
        let elapsed = Date().timeIntervalSince(startTime)
        let duration = getSoundDuration(from: soundPath)
        return max(duration - elapsed, 0)
    }
}

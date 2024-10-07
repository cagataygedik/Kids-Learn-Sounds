//
//  AnimationManager.swift
//  Animal Sounds
//
//  Created by Celil Çağatay Gedik on 7.10.2024.
//

import Foundation
import Lottie

final class AnimationManager {
    static let sharedLoadingAnimation: LottieAnimationView = {
        let animation = LottieAnimationView(name: "LoadingAnimation")
        animation.loopMode = .loop
        return animation
    }()
    
    static let sharedOnboardingAnimalsAnimation: LottieAnimationView = {
        let animation = LottieAnimationView(name: "AnimalsAnimation")
        animation.loopMode = .loop
        animation.contentMode = .scaleAspectFit
        return animation
    }()
    
    static let sharedOnboardingPenguinMusicAnimation: LottieAnimationView = {
        let animation = LottieAnimationView(name: "PenguinMusic")
        animation.loopMode = .loop
        animation.contentMode = .scaleAspectFit
        return animation
    }()
}

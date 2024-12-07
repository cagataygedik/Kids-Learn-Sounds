//
//  SceneDelegate.swift
//  Animal Sounds
//
//  Created by Celil Çağatay Gedik on 4.05.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = Constants.mainBackgroundColor
        
        let fontWeight: UIFont.Weight = .heavy
//        let fontWeight: UIFont.Weight = .bold
        
        if let fontDescriptor = UIFont.systemFont(ofSize: 35, weight: fontWeight).fontDescriptor.withDesign(.rounded) {
            // Create the font using the descriptor
            let baseFont = UIFont(descriptor: fontDescriptor, size: 35)
            // Use UIFontMetrics for Dynamic Type support
            let font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: baseFont)
            
            appearance.titleTextAttributes = [
                .foregroundColor: UIColor.black
//                .font: font
            ]
            
            appearance.largeTitleTextAttributes = [
                .foregroundColor: UIColor.black,
                .font: font
            ]
        } else {
            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
            appearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        }
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        
        let userDefaults = UserDefaults.standard
        if userDefaults.bool(forKey: "hasLaunchedBefore") {
            window?.rootViewController = KLSTabBarController()
        } else {
            window?.rootViewController = KLSOnboardingViewController()
            userDefaults.set(true, forKey: "hasLaunchedBefore")
        }
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}


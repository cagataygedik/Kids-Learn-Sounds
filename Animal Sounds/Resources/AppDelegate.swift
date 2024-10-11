//
//  AppDelegate.swift
//  Animal Sounds
//
//  Created by Celil Çağatay Gedik on 4.05.2024.
//

import UIKit
import RevenueCat

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


//I was getting warning so I came up an with solution. If this encounter something in the future I will change that.
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Purchases.configure(withAPIKey: "appl_iooFWWrxEFneojYqggeRccnCLgh")
        DispatchQueue.global().async {
                    let fileManager = FileManager.default
                    do {
                        // Get the documents directory
                        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                        
                        // Append the directory name to the documents path
                        let directoryPath = documentsPath.appendingPathComponent("MyDirectory").path
                        
                        // Create the directory if it doesn't exist
                        try fileManager.createDirectory(atPath: directoryPath, withIntermediateDirectories: true, attributes: nil)
                    } catch {
                        print("Error creating directory: \(error)")
                    }
                }
                
                return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}


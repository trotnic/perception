//
//  AppDelegate.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 27.11.21.
//

import UIKit
import PerceptionStorage

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let fireManager = PCNFireManager.shared

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        fireManager.storeManager.check()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}

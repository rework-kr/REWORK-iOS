//
//  SceneDelegate.swift
//  REWORK
//
//  Created by YoungK on 4/14/24.
//  Copyright © 2024 youngkyu.song. All rights reserved.
//

import UIKit
import IntroFeature

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let scene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: scene)
        self.window?.rootViewController = IntroViewController()
        self.window?.makeKeyAndVisible()
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
    }
    
    // MARK: - Handling DeepLink
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    }
    
    // MARK: - Handling UniveralLink
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
    }
    
}

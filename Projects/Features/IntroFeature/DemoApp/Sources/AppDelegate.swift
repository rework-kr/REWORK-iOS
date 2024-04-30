//
//  AppDelegate.swift
//  REWORK
//
//  Created by YoungK on 4/14/24.
//  Copyright © 2024 youngkyu.song. All rights reserved.
//

import Foundation
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        print("didFinishLaunchingWithOptions")
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return false }
        self.window = UIWindow(windowScene: windowScene)
        window?.rootViewController = DemoIntroViewController()
        window?.makeKeyAndVisible()

        return true
    }
}

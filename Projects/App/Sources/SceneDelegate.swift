//
//  SceneDelegate.swift
//  REWORK
//
//  Created by YoungK on 4/14/24.
//  Copyright © 2024 youngkyu.song. All rights reserved.
//

import UIKit
import AuthDomain
import KeychainModule
import RootFeature
import RxSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var disposeBag = DisposeBag()
    var window: UIWindow?
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let scene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: scene)
        
        let keychain = KeychainImpl()
        let local = LocalAuthDataSourceImpl(keychain: keychain)
        let remote = RemoteAuthDataSourceImpl(keychain: keychain)
        let repository = AuthRepositoryImpl(localAuthDataSource: local, remoteAuthDataSource: remote)
        let checkIsExistAccessTokenUseCase = CheckIsExistAccessTokenUseCaseImpl(authRepository: repository)
        let reactor = RootReactor(checkIsExistAccessTokenUseCase: checkIsExistAccessTokenUseCase)
        
        let vc = UINavigationController(rootViewController: RootViewController(reactor: reactor))
        self.window?.rootViewController = vc
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

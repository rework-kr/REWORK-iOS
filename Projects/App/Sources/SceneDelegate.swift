//
//  SceneDelegate.swift
//  REWORK
//
//  Created by YoungK on 4/14/24.
//  Copyright © 2024 youngkyu.song. All rights reserved.
//

import UIKit
import SignInFeature
import HomeFeature
import MainTabFeature
import AuthDomain
import KeychainModule
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
        var entryViewController: UIViewController = SignInViewController()
        checkIsExistAccessTokenUseCase.execute()
            .asObservable()
            .flatMap { isExist in
                return isExist ? Observable.just(true) : Observable.just(false)
            }
            .subscribe { isExist in
                entryViewController = isExist ? MainTabViewController(reactor: MainTabReactor()) : SignInViewController()
            }
            .disposed(by: disposeBag)
        
        let vc = UINavigationController(rootViewController: MainTabViewController(reactor: MainTabReactor()))
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

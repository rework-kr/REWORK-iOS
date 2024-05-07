import Foundation
import UIKit
import Inject

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
        
        let viewController = Inject.ViewControllerHost(
            UINavigationController(rootViewController: DemoSignUpViewController())
        )
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()

        return true
    }
}

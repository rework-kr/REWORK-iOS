import BaseFeature
import SignInFeature
import HomeFeature
import MainTabFeature
import AuthDomain
import KeychainModule
import RxSwift
import UIKit
import SnapKit
import Then

public final class RootViewController: BaseReactorViewController<RootReactor>, UINavigationControllerDelegate {
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationController?.delegate = self
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        reactor?.action.onNext(.viewDidLoad)
    }
    
    public override func bindState(reactor: RootReactor) {
        reactor.pulse(\.$isLoggedIn)
            .compactMap { $0 }
            .bind(with: self, onNext: { owner, isLoggedIn in
                if isLoggedIn {
                    self.showMainTabViewController()
                } else {
                    self.showSignInViewController()
                }
            }).disposed(by: disposeBag)
            
    }
    
    public override func bindAction(reactor: RootReactor) {
        
    }
    
    private func showMainTabViewController() {
        self.navigationController?.popToRootViewController(animated: false)
        let mainTabVC = MainTabViewController(reactor: MainTabReactor())
        self.navigationController?.pushViewController(mainTabVC, animated: false)
    }
    
    private func showSignInViewController() {
        self.navigationController?.popToRootViewController(animated: false)
        let signInVC = SignInViewController()
        self.navigationController?.pushViewController(signInVC, animated: false)
    }
    
}

//
//  SignInViewController.swift
//  SignInFeature
//
//  Created by YoungK on 4/14/24.
//  Copyright © 2024 youngkyu.song. All rights reserved.
//
import BaseFeature
import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import ReactorKit
import Foundation

public final class SignInViewController: BaseViewController {
    public var disposeBag = DisposeBag()
    var introView: SignInView!
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        introView = SignInView(frame: self.view.frame)
        self.view.addSubview(introView)
        self.reactor = SignInReactor()
        reactor?.action.onNext(.viewDidLoad)
    }

}

extension SignInViewController: View {
    public func bind(reactor: SignInReactor) {
        introView.accountTextField.rx.text
            .map { Reactor.Action.setEmail($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .debug()
            .map { $0.viewDidLoaded }
            .subscribe(onNext: { [weak self] viewDidLoaded in
                guard let self else { return }
                UIView.animate(withDuration: 1.0) {
                    self.introView.accountTextField.alpha = viewDidLoaded ? CGFloat(1.0) : CGFloat(0)
                }
            }).disposed(by: disposeBag)
        
        reactor.state
            .map { $0.validationResult }
            .map { return $0 == .ok ? true : false }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] emailIsValid in
                guard let self else { return }
                UIView.animate(withDuration: 0.3) {
                    self.introView.passwordTextField.alpha = emailIsValid ? CGFloat(1.0) : CGFloat(0)
                    self.introView.passwordTextField.transform = emailIsValid ?
                    CGAffineTransform(translationX: 0, y: 0)
                    : CGAffineTransform(translationX: 0, y: 20)
                }
            }).disposed(by: disposeBag)
    }
}

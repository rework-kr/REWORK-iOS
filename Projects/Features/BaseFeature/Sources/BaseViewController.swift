//
//  BaseViewController.swift
//  BaseFeature
//
//  Created by YoungK on 4/14/24.
//  Copyright © 2024 youngkyu.song. All rights reserved.
//

import ReactorKit
import RxSwift
import SnapKit
import Then
import UIKit

open class BaseViewController: UIViewController, BaseViewControllerProtocol {
    override open func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        setLayout()
    }
}

private protocol BaseViewControllerProtocol {
    func addSubViews()
    func setLayout()
}

extension BaseViewControllerProtocol {
    func addSubViews() {}
    func setLayout() {}
}



open class BaseReactorViewController<R: Reactor>: UIViewController, View {
    public var disposeBag = DisposeBag()

    public init(reactor: R) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        addView()
        setLayout()
        configureUI()
        configureNavigation()
    }

    open func bind(reactor: R) {
        bindState(reactor: reactor)
        bindAction(reactor: reactor)
    }

    open func addView() {}
    open func setLayout() {}
    open func configureUI() {}

    open func configureNavigation() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    open func bindState(reactor: R) {}
    open func bindAction(reactor: R) {}
}

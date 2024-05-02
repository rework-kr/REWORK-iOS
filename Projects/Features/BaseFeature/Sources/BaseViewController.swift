//
//  BaseViewController.swift
//  BaseFeature
//
//  Created by YoungK on 4/14/24.
//  Copyright © 2024 youngkyu.song. All rights reserved.
//

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

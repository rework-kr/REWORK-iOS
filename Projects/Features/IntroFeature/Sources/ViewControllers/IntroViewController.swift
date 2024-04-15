//
//  IntroViewController.swift
//  IntroFeature
//
//  Created by YoungK on 4/14/24.
//  Copyright © 2024 youngkyu.song. All rights reserved.
//

import Foundation
import UIKit
import BaseFeature

class IntroViewController: BaseViewController {
    var introView: IntroView!
    var viewModel: IntroViewModel!
    
    init(viewModel: IntroViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        introView = IntroView(frame: self.view.frame)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

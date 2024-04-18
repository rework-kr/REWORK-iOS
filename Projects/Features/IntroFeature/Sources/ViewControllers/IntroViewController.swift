//
//  IntroViewController.swift
//  IntroFeature
//
//  Created by YoungK on 4/14/24.
//  Copyright © 2024 youngkyu.song. All rights reserved.
//
import BaseFeature
import UIKit
import RxSwift
import SnapKit
import Then
import ReactorKit

public final class IntroViewController: BaseViewController {
    var introView: IntroView!
    var disposeBag = DisposeBag()
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
    }
    
    public override func loadView() {
        super.loadView()
        introView = IntroView(frame: self.view.frame)
        self.view.addSubview(introView)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}

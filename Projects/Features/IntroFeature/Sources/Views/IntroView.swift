//
//  IntroView.swift
//  IntroFeature
//
//  Created by YoungK on 4/14/24.
//  Copyright © 2024 youngkyu.song. All rights reserved.
//

import UIKit
import DesignSystem
import SnapKit
import Then
import Utility

public final class IntroView: UIView {
    lazy var logoImageView = UIImageView().then {
        $0.image = DesignSystemAsset.rework.image
    }
    
    lazy var accountTextField = UITextField().then {
        $0.placeholder = "계정 정보를 입력해주세요"
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

private extension IntroView {
    func configureUI() {
        
    }
}


//
//  SignInView.swift
//  SignInFeature
//
//  Created by YoungK on 4/14/24.
//  Copyright © 2024 youngkyu.song. All rights reserved.
//

import UIKit
import DesignSystem
import BaseFeature
import SnapKit
import Then
import Utility

public final class SignInView: BaseView {
    lazy var logoImageView = UIImageView().then {
        $0.image = DesignSystemAsset.SignIn.rework.image
    }
    
    lazy var descriptionView = DescriptionView().then {
        $0.title = "우리는 효율적으로 일하는 리워크입니다."
        $0.content = "리워크는 업무 효울성을 위한 기록용 아카이빙 서비스를 제공하고 있어요\n소규모 회원을 위한 서비스 품질을 위해 폐쇄성 있는 서비스를 제공해요"
        $0.footer = "이메일을 기재해주시면 컨택 메일을 드릴게요"
    }
    
    lazy var accountTextField = UITextField().then {
        $0.font = DesignSystemFontFamily.Pretendard.medium.font(size: 12)
        $0.attributedPlaceholder = NSAttributedString(
            string: "계정 정보를 입력해주세요",
            attributes: [
                .font: DesignSystemFontFamily.Pretendard.medium.font(size: 12)
            ]
        )
        $0.layer.cornerRadius = 20
        $0.layer.masksToBounds = true
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(hex: "EDEDED").cgColor
        $0.horizontalPadding(10)
        $0.alpha = 0
    }
    
    lazy var passwordTextField = UITextField().then {
        $0.font = DesignSystemFontFamily.Pretendard.medium.font(size: 12)
        $0.attributedPlaceholder = NSAttributedString(
            string: "비밀번호를 입력해주세요",
            attributes: [
                .font: DesignSystemFontFamily.Pretendard.medium.font(size: 12)
            ]
        )
        $0.layer.cornerRadius = 20
        $0.layer.masksToBounds = true
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(hex: "EDEDED").cgColor
        $0.horizontalPadding(10)
        $0.alpha = 0
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

private extension SignInView {
    func addSubViews() {
        self.addSubview(logoImageView)
        self.addSubview(descriptionView)
        self.addSubview(accountTextField)
        self.addSubview(passwordTextField)
    }
    
    func setLayout() {
        self.backgroundColor = .white
        let descriptionViewHeight: CGFloat = 200
        
        logoImageView.snp.makeConstraints {
            $0.width.height.equalTo(50)
            $0.centerX.equalToSuperview()
            let descriptionViewTop = (APP_HEIGHT() / 2) - descriptionViewHeight
            let centerY = (descriptionViewTop + STATUS_BAR_HEIGHT()) / 2
            $0.centerY.equalTo(centerY)
        }
        
        descriptionView.snp.makeConstraints {
            $0.height.equalTo(descriptionViewHeight)
            $0.bottom.equalTo(self.snp.centerY)
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        accountTextField.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.top.equalTo(descriptionView.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        passwordTextField.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.top.equalTo(accountTextField.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
    }
    
    
}


//
//  DescriptionView.swift
//  SignInFeature
//
//  Created by YoungK on 4/15/24.
//  Copyright © 2024 youngkyu.song. All rights reserved.
//

import UIKit
import SnapKit
import Then
import DesignSystem

public class DescriptionView: UIView {
    let backgroundView = UIView().then {
        $0.layer.cornerRadius = 8
        $0.backgroundColor = UIColor(hex: "2D2D2D")
    }
    
    //let contentView  = UIView()
    //let scrollView = UIScrollView()
    
    let titleLabel = UILabel().then {
        $0.font = DesignSystemFontFamily.Pretendard.bold.font(size: 16)
        $0.textAlignment = .center
        $0.textColor = .white
    }
    let contentLabel = UILabel().then {
        $0.font = DesignSystemFontFamily.Pretendard.medium.font(size: 10)
        $0.textAlignment = .center
        $0.textColor = .white
        $0.numberOfLines = 0
    }
    let footerLabel = UILabel().then {
        $0.font = DesignSystemFontFamily.Pretendard.medium.font(size: 10)
        $0.textAlignment = .center
        $0.textColor = .gray
    }
    
    public var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    public var content: String? {
        didSet {
            contentLabel.text = content
        }
    }
    
    public var footer: String? {
        didSet {
            footerLabel.text = footer
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews()
        setLayout()
    }
    
    func addSubViews() {
        addSubview(backgroundView)
        addSubview(titleLabel)
        addSubview(contentLabel)
        addSubview(footerLabel)
    }
    
    func setLayout() {
        backgroundView.snp.makeConstraints {
            $0.verticalEdges.horizontalEdges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(contentLabel.snp.top)
        }
        
        contentLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.centerX.centerY.equalToSuperview()
            $0.height.equalTo(80)
        }
        
        footerLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.top.equalTo(contentLabel.snp.bottom)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


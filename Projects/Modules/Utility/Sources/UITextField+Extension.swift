//
//  UITextField+Extension.swift
//  Utility
//
//  Created by YoungK on 4/19/24.
//  Copyright © 2024 youngkyu.song. All rights reserved.
//

import UIKit

public extension UITextField {
    
    /// 텍스트 필드 내 좌우 여백을 추가합니다.
    func horizontalPadding(_ value: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: value, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
        self.rightView = paddingView
        self.rightViewMode = ViewMode.always
    }
}

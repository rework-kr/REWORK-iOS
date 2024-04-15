//
//  FontSystem.swift
//  DesignSystem
//
//  Created by YoungK on 4/14/24.
//  Copyright © 2024 youngkyu.song. All rights reserved.
//

import Foundation
import SwiftUI

public extension Font {
    enum FontSystem: String {
        case light = "Pretendard-Light"
        case medium = "Pretendard-Medium"
        case bold = "Pretendard-Bold"
        
        func font(size: CGFloat, weight: Font.Weight) -> Font {
            if let uiFont = UIFont(name: self.rawValue, size: size) {
                return Font(uiFont).weight(weight)
            } else {
                return Font.system(size: size).weight(weight)
            }
        }

        public static func light(size: CGFloat) -> Font {
            return FontSystem.light.font(size: size, weight: .light)
        }
        
        public static func medium(size: CGFloat) -> Font {
            return FontSystem.medium.font(size: size, weight: .medium)
        }
        
        public static func bold(size: CGFloat) -> Font {
            return FontSystem.bold.font(size: size, weight: .bold)
        }
    }

}

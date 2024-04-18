//
//  Color+Extension.swift
//  Utility
//
//  Created by YoungK on 4/14/24.
//  Copyright © 2024 youngkyu.song. All rights reserved.
//

import UIKit

//extension Color {
//    init(hex: String) {
//        let scanner = Scanner(string: hex)
//        var rgbValue: UInt64 = 0
//        scanner.scanHexInt64(&rgbValue)
//        
//        let red = (rgbValue & 0xff0000) >> 16
//        let green = (rgbValue & 0xff00) >> 8
//        let blue = rgbValue & 0xff
//        
//        self.init(red: Double(red)/0xff, green: Double(green)/0xff, blue: Double(blue)/0xff)
//    }
//    
//}

public extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
            var hexFormatted: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
            
            if hexFormatted.hasPrefix("#") {
                hexFormatted = String(hexFormatted.dropFirst())
            }
            
            assert(hexFormatted.count == 6, "Invalid hex code used.")
            
            var rgbValue: UInt64 = 0
            Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
            
            self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                      green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                      blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                      alpha: alpha)
        }
}

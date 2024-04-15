//
//  Utils.swift
//  Utility
//
//  Created by YoungK on 4/14/24.
//  Copyright © 2024 youngkyu.song. All rights reserved.
//

import Foundation
import SwiftUI

public func APP_WIDTH() -> CGFloat {
    return UIScreen.main.bounds.size.width
}

public func APP_HEIGHT() -> CGFloat {
    return UIScreen.main.bounds.size.height
}

public func STATUS_BAR_HEIGHT() -> CGFloat {
    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
       let statusBarManager = windowScene.statusBarManager {
        return max(20, statusBarManager.statusBarFrame.height)
    }
    return 20
}

public func SAFEAREA_BOTTOM_HEIGHT() -> CGFloat {
    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
        return windowScene.windows.first?.safeAreaInsets.bottom ?? 0
    }
    return 0
}

// use: colorFromRGB(0xffffff)
public func colorFromRGB(_ rgbValue: UInt, alpha: CGFloat = 1.0) -> UIColor {
    return UIColor(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                   green: CGFloat((rgbValue & 0xFF00) >> 8) / 255.0,
                   blue: CGFloat(rgbValue & 0xFF) / 255.0, alpha: alpha)
}

// use: colorFromRGB("ffffff")
public func colorFromRGB(_ hexString: String, alpha: CGFloat = 1.0) -> UIColor {
    let hexToInt = UInt32(Float64("0x" + hexString) ?? 0)
    return UIColor(red: CGFloat((hexToInt & 0xFF0000) >> 16) / 255.0,
                   green: CGFloat((hexToInt & 0xFF00) >> 8) / 255.0,
                   blue: CGFloat(hexToInt & 0xFF) / 255.0, alpha: alpha)
}

public func APP_NAME() -> String {
    return Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? ""
}

public func APP_VERSION() -> String {
    return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
}

public func OS_VERSION() -> String {
    return UIDevice.current.systemVersion
}

public func OS_NAME() -> String {
    let osName: String = {
        #if os(iOS)
        #if targetEnvironment(macCatalyst)
        return "macOS(Catalyst)"
        #else
        return "iOS"
        #endif
        #elseif os(watchOS)
        return "watchOS"
        #elseif os(tvOS)
        return "tvOS"
        #elseif os(macOS)
        return "macOS"
        #elseif os(Linux)
        return "Linux"
        #elseif os(Windows)
        return "Windows"
        #else
        return "Unknown"
        #endif
    }()
    return osName
}

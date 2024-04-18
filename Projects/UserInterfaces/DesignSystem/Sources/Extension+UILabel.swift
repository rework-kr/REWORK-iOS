//
//  Extension+UILabel.swift
//  DesignSystem
//
//  Created by YoungK on 4/15/24.
//  Copyright © 2024 youngkyu.song. All rights reserved.
//

import UIKit

public extension UILabel {
    /// 레이블의 높이, 자간, 행간을 조절하는 메소드입니다.
    /// - Parameter lineHeight: 레이블 자체의 높이
    /// - Parameter kernValue: 글자간의 간격
    /// - Parameter lineSpacing: 줄 간격 (한 줄과 다음 줄 사이의 간격)
    /// - Parameter lineHeightMultiple: 줄 간격의 배수 (lineSpacing *  lineHeightMultiple)
    func setTextWithAttributes(
        lineHeight: CGFloat? = nil,
        kernValue: Double? = nil,
        lineSpacing: CGFloat? = nil,
        lineHeightMultiple: CGFloat? = nil,
        alignment: NSTextAlignment = .left
    ) {
        guard let labelText = self.text else { return }

        let paragraphStyle = NSMutableParagraphStyle()

        if let lineSpacing { paragraphStyle.lineSpacing = lineSpacing }
        if let lineHeightMultiple { paragraphStyle.lineHeightMultiple = lineHeightMultiple }

        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.alignment = alignment

        let style = NSMutableParagraphStyle()

        let baselineOffset: CGFloat

        if let lineHeight {
            style.maximumLineHeight = lineHeight
            style.minimumLineHeight = lineHeight
            baselineOffset = (lineHeight - font.lineHeight) / 2
        } else {
            baselineOffset = 0
        }

        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: paragraphStyle,
            .kern: kernValue ?? 0.0,
            .baselineOffset: baselineOffset
        ]

        let attributedString = NSMutableAttributedString(string: labelText, attributes: attributes)

        self.attributedText = attributedString
    }
}

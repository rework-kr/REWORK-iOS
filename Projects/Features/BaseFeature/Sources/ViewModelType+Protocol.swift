//
//  ViewModelType+Protocol.swift
//  BaseFeature
//
//  Created by YoungK on 4/14/24.
//  Copyright © 2024 youngkyu.song. All rights reserved.
//

import Foundation

public protocol ViewModelType {
    associatedtype Input
    associatedtype Output

    func transform(from input: Input) -> Output
}

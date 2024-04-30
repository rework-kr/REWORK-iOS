//
//  SignInReactor.swift
//  SignInFeature
//
//  Created by YoungK on 4/19/24.
//  Copyright © 2024 youngkyu.song. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift

public enum ValidationResult: Equatable {
    case ok, no(_ msg: String)
}

public final class SignInReactor: Reactor {
    public var initialState: State
    
    public enum Action {
        case viewDidLoad
        case setEmail(String?)
        
    }
    
    public enum Mutation {
        case viewDidLoaded
        case setEmailInfo((email: String, validationResult: ValidationResult))
    }
    
    public struct State {
        var email: String
        var viewDidLoaded: Bool
        var validationResult: ValidationResult?
    }
    
    init() {
        self.initialState = .init(
            email: "", 
            viewDidLoaded: false
        )
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return .just(Mutation.viewDidLoaded)
        case .setEmail(let email):
            guard let email else { return .empty() }
            return .just(Mutation.setEmailInfo((email, email.validEmail)))
            
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = State(email: state.email, viewDidLoaded: state.viewDidLoaded)
        switch mutation {
        case .viewDidLoaded:
            newState.viewDidLoaded = true
            
        case .setEmailInfo(let info):
            newState.email = info.email
            newState.validationResult = info.validationResult
        }
        return newState
    }
    
    
}

extension String {
    var isNotEmpty: Bool {
        return !self.isEmpty
    }

    var validEmail: ValidationResult {
        return self.isEmail ? ValidationResult.ok : ValidationResult.no("This is not an email format.")
    }

    var isEmail: Bool {
        let EMAIL_REGEX = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", EMAIL_REGEX).evaluate(with: self)
    }
}

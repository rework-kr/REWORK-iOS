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
        case keyboardWillShow(CGFloat)
        case keyboardWillHide
        case setEmail(String?)
        case loginButtonDidTap
    }
    
    public enum Mutation {
        case viewDidLoaded
        case setKeyboardHeight(CGFloat)
        case setEmailInfo((email: String, validationResult: ValidationResult))
        case isLoggedIn(Bool)
    }
    
    public struct State {
        public var keyboardHeight: CGFloat
        public var email: String
        public var viewDidLoaded: Bool
        public var validationResult: ValidationResult?
        public var loggedIn: Bool
    }
    
    public init() {
        self.initialState = .init(
            keyboardHeight: 0,
            email: "",
            viewDidLoaded: false, 
            loggedIn: false
        )
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        print("✅ mutate 호출됨", action)
        switch action {
        case .viewDidLoad:
            return .just(.viewDidLoaded)
            
        case .keyboardWillShow(let height):
            return .just(.setKeyboardHeight(height))
            
        case .keyboardWillHide:
            return .just(.setKeyboardHeight(0))
            
        case .setEmail(let email):
            guard let email else { return .empty() }
            return .just(.setEmailInfo((email, email.validEmail)))
            
            
        case .loginButtonDidTap:
            return fetchUserInfo()
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        print("🚀 reduce 호출됨", mutation)
        var newState = state
        switch mutation {
        case .viewDidLoaded:
            newState.viewDidLoaded = true
            
        case .setKeyboardHeight(let height):
            newState.keyboardHeight = height
            
        case .setEmailInfo(let info):
            newState.email = info.email
            newState.validationResult = info.validationResult
            
        case .isLoggedIn(let isLoggedIn):
            newState.loggedIn = isLoggedIn
        }
        return newState
    }
    
}

private extension SignInReactor {
    func fetchUserInfo() -> Observable<Mutation> {
        return .just(Mutation.isLoggedIn(true))
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

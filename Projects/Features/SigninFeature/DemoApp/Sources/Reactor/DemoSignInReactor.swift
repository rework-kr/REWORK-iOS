import UIKit
import ReactorKit
import RxSwift

public enum ValidationResult: Equatable {
    case ok, no(_ msg: String)
}

public final class DemoSignInReactor: Reactor {
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
        var keyboardHeight: CGFloat
        var email: String
        var viewDidLoaded: Bool
        var validationResult: ValidationResult?
        var loggedIn: Bool
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

private extension DemoSignInReactor {
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

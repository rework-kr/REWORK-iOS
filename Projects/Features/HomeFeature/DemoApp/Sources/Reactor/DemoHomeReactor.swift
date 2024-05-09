import UIKit
import ReactorKit
import RxSwift

public final class DemoHomeReactor: Reactor {
    public var initialState: State
    
    public enum Action {
        case viewDidLoad
        case keyboardWillShow(CGFloat)
        case keyboardWillHide
    }
    
    public enum Mutation {
        case viewDidLoaded
        case setKeyboardHeight(CGFloat)
    }
    
    public struct State {
        var keyboardHeight: CGFloat
        var viewDidLoaded: Bool
    }
    
    public init() {
        self.initialState = .init(
            keyboardHeight: 0,
            viewDidLoaded: false
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
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .viewDidLoaded:
            newState.viewDidLoaded = true
            
        case .setKeyboardHeight(let height):
            newState.keyboardHeight = height
        }
        return newState
    }
    
}

private extension DemoHomeReactor {
    func fetchMossiggang() -> Observable<Mutation> {
        return .just(.viewDidLoaded)
    }
}

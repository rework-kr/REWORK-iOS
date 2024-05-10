import UIKit
import ReactorKit
import RxSwift

public struct KeyboardState: Equatable {
    let isShow: Bool
    let height: CGFloat
}

public final class DemoHomeReactor: Reactor {
    public var initialState: State
    
    public enum Action {
        case viewDidLoad
        case keyboardWillShow(CGFloat)
        case keyboardWillHide
    }
    
    public enum Mutation {
        case viewDidLoaded
        case setKeyboardState(KeyboardState)
    }
    
    public struct State {
        var keyboardState: KeyboardState
        var viewDidLoaded: Bool
    }
    
    public init() {
        self.initialState = .init(
            keyboardState: KeyboardState(isShow: false, height: 0),
            viewDidLoaded: false
        )
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return .just(.viewDidLoaded)
            
        case .keyboardWillShow(let height):
            return .just(.setKeyboardState(KeyboardState(isShow: true, height: height)))
            
        case .keyboardWillHide:
            return .just(.setKeyboardState(KeyboardState(isShow: false, height: 0)))
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .viewDidLoaded:
            newState.viewDidLoaded = true
            
        case .setKeyboardState(let keyboardState):
            newState.keyboardState = keyboardState
        }
        return newState
    }
    
}

private extension DemoHomeReactor {
    func fetchMossiggang() -> Observable<Mutation> {
        return .just(.viewDidLoaded)
    }
}

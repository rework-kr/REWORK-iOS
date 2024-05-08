import UIKit
import ReactorKit
import RxSwift

public final class SignUpAfterReactor: Reactor {
    public var initialState: State
    
    public enum Action {
        case viewDidLoad

    }
    
    public enum Mutation {
        case viewDidLoaded

    }
    
    public struct State {
        var viewDidLoaded: Bool
    }
    
    public init() {
        self.initialState = .init(
            viewDidLoaded: false
        )
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return .just(.viewDidLoaded)
            
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .viewDidLoaded:
            newState.viewDidLoaded = true
        }
        return newState
    }
    
}

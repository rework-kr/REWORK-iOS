import Foundation
import RxSwift
import ReactorKit

public final class MainTabReactor: Reactor {
    public var initialState: State
    
    public enum Action {
        case viewDidLoad
        case tabItemDidTap(TabItemType)
    }
    
    public enum Mutation {
        case switchTab(tabItemType: TabItemType)
    }
    
    public struct State {
        var tab: TabItemType
    }
    
    public init() {
        self.initialState = .init(
            tab: .home
        )
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return .empty()
        case .tabItemDidTap(let tabItemType):
            return tabItemDidTap(tabItemType)
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .switchTab(let tabItemType):
            newState.tab = tabItemType
        }
        return newState
    }
}

private extension MainTabReactor {
    func tabItemDidTap(_ tabItemType: TabItemType) -> Observable<Mutation> {
        return .empty()
    }
}

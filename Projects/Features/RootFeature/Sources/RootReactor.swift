import ReactorKit
import Foundation
import RxCocoa
import AuthDomain
import KeychainModule

public final class RootReactor: Reactor {
    
    
    public enum Action {
        case viewDidLoad
        case changeLoginState(Bool)
    }
    
    public enum Mutation {
        case loginStatus(Bool)
    }
    
    public struct State {
        @Pulse var isLoggedIn: Bool?
    }
    
    public var initialState: State
    private let disposeBag = DisposeBag()
    
    private let checkIsExistAccessTokenUseCase: CheckIsExistAccessTokenUseCase
    
    public init(
        checkIsExistAccessTokenUseCase: CheckIsExistAccessTokenUseCase
    ) {
        self.checkIsExistAccessTokenUseCase = checkIsExistAccessTokenUseCase
        self.initialState = State()
        setNotification()
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return ViewDidLoad()
            
        case let .changeLoginState(isLoggedIn):
            return ChangeLoginState(isLoggedIn)
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .loginStatus(let isLoggedIn):
            newState.isLoggedIn = isLoggedIn
        }
        return newState
    }
    
    private func ViewDidLoad() -> Observable<Mutation> {
        return checkIsExistAccessTokenUseCase.execute()
            .catchAndReturn(false)
            .map { Mutation.loginStatus($0) }
            .asObservable()
    }
    
    private func ChangeLoginState(_ isLoggedIn: Bool) -> Observable<Mutation> {
        return .just(.loginStatus(isLoggedIn))
    }
    
}

private extension RootReactor {
    func setNotification() {
        NotificationCenter.default.rx.notification(.loginStateDidChanged)
            .compactMap { $0.object as? Bool }
            .bind(with: self) { owner, isLoggedIn in
                owner.action.onNext(.changeLoginState(isLoggedIn))
            }.disposed(by: disposeBag)
    }
}

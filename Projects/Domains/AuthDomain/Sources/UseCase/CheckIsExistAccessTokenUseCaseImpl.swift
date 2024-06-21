import Foundation
import RxSwift

public protocol CheckIsExistAccessTokenUseCase {
    func execute() -> Single<Bool>
}

public struct CheckIsExistAccessTokenUseCaseImpl: CheckIsExistAccessTokenUseCase {
    private let authRepository: any AuthRepository

    public init(authRepository: any AuthRepository) {
        self.authRepository = authRepository
    }

    public func execute() -> Single<Bool> {
        authRepository.checkIsExistAccessToken()
    }
}

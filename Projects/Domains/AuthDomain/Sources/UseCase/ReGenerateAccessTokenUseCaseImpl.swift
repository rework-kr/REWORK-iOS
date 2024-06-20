import Foundation
import RxSwift

public protocol ReGenerateAccessTokenUseCase {
    func execute() -> Single<TokenEntity>
}

public struct ReGenerateAccessTokenUseCaseImpl: ReGenerateAccessTokenUseCase {
    private let authRepository: any AuthRepository

    public init(authRepository: any AuthRepository) {
        self.authRepository = authRepository
    }

    public func execute() -> Single<TokenEntity> {
        authRepository.reGenerateAccessToken()
    }
}

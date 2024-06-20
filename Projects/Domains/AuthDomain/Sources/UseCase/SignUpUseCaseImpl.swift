import Foundation
import RxSwift

public protocol SignUpUseCase {
    func execute(email: String) -> Single<SignUpEntity>
}

public struct SignUpUseCaseImpl: SignUpUseCase {
    private let authRepository: any AuthRepository

    public init(authRepository: any AuthRepository) {
        self.authRepository = authRepository
    }

    public func execute(email: String) -> Single<SignUpEntity> {
        authRepository.signUp(email: email)
    }
}

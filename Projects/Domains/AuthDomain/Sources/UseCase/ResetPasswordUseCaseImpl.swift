import Foundation
import RxSwift

public protocol ResetPasswordUseCase {
    func execute(userId: String, oldPassword: String, newPassword: String) -> Single<ResetPasswordEntity>
}

public struct ResetPasswordUseCaseImpl: ResetPasswordUseCase {
    private let authRepository: any AuthRepository

    public init(authRepository: any AuthRepository) {
        self.authRepository = authRepository
    }

    public func execute(userId: String, oldPassword: String, newPassword: String) -> Single<ResetPasswordEntity> {
        authRepository.resetPassword(userId: userId, oldPassword: oldPassword, newPassword: newPassword)
    }
}

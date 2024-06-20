import Foundation
import RxSwift

public protocol UserInfoUserCase {
    func execute() -> Single<UserInfoEntity>
}

public struct UserInfoUserCaseImpl: UserInfoUserCase {
    private let authRepository: any AuthRepository

    public init(authRepository: any AuthRepository) {
        self.authRepository = authRepository
    }

    public func execute() -> Single<UserInfoEntity> {
        authRepository.getUserInfo()
    }
}

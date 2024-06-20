import RxSwift

public protocol AuthRepository {
    func resetPassword(userId: String, oldPassword: String, newPassword: String) -> Single<ResetPasswordEntity>
    func reGenerateAccessToken() -> Single<TokenEntity>
    func signUp(email: String) -> Single<SignUpEntity>
    func getUserInfo() -> Single<UserInfoEntity>
    func logout() -> Completable
    func checkIsExistAccessToken() -> Single<Bool>
}

public final class AuthRepositoryImpl: AuthRepository {
    private let localAuthDataSource: any LocalAuthDataSource
    private let remoteAuthDataSource: any RemoteAuthDataSource

    public init(
        localAuthDataSource: any LocalAuthDataSource,
        remoteAuthDataSource: any RemoteAuthDataSource
    ) {
        self.localAuthDataSource = localAuthDataSource
        self.remoteAuthDataSource = remoteAuthDataSource
    }
    
    public func resetPassword(userId: String, oldPassword: String, newPassword: String) -> RxSwift.Single<ResetPasswordEntity> {
        remoteAuthDataSource.resetPassword(userId: userId, oldPassword: oldPassword, newPassword: newPassword)
    }
    public func reGenerateAccessToken() -> Single<TokenEntity> {
        remoteAuthDataSource.reGenerateAccessToken()
    }
    public func signUp(email: String) -> Single<SignUpEntity> {
        remoteAuthDataSource.signUp(email: email)
    }
    
    public func getUserInfo() -> Single<UserInfoEntity> {
        remoteAuthDataSource.getUserInfo()
    }
    public func logout() -> Completable {
        remoteAuthDataSource.logout()
        localAuthDataSource.logout()
        return .empty()
    }
    
    public func checkIsExistAccessToken() -> Single<Bool> {
        let isExist = localAuthDataSource.checkIsExistAccessToken()
        return .just(isExist)
    }

}

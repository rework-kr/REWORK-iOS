import Moya
import BaseDomain
import RxSwift
import KeychainModule

public protocol RemoteAuthDataSource {
    func resetPassword(userId: String, oldPassword: String, newPassword: String) -> Single<ResetPasswordEntity>
    func reGenerateAccessToken() -> Single<TokenEntity>
    func signUp(email: String) -> Single<SignUpEntity>
    func logout() -> Single<Bool>
    func getUserInfo() -> Single<UserInfoEntity>
}

public final class RemoteAuthDataSourceImpl: BaseRemoteDataSource<AuthAPI>, RemoteAuthDataSource {
    public func resetPassword(userId: String, oldPassword: String, newPassword: String) -> Single<ResetPasswordEntity> {
        return request(.resetPassword(userId: userId, oldPassword: oldPassword, newPassword: newPassword))
            .map(ResetPasswordResponseDTO.self)
            .map { $0.toDomain() }
    }
    
    public func reGenerateAccessToken() -> Single<TokenEntity> {
        return request(.reGenerateAccessToken)
            .map(TokenResponseDTO.self)
            .map { $0.toDomain() }
    }
    
    public func signUp(email: String) -> Single<SignUpEntity> {
        return request(.signUp(email: email))
            .map(SignupResponseDTO.self)
            .map { $0.toDomain() }
    }
    
    public func logout() -> Single<Bool> {
        return request(.logout)
            .map { response in
                return (200...299).contains(response.statusCode)
            }
            .catchAndReturn(false)
    }
    
    public func getUserInfo() -> Single<UserInfoEntity> {
        return request(.userInfo)
            .map(UserInfoResponseDTO.self)
            .map { $0.toDomain() }
    }
}

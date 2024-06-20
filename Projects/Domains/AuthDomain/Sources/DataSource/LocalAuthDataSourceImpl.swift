import KeychainModule
import RxSwift
import Utility

public protocol LocalAuthDataSource {
    func logout()
    func checkIsExistAccessToken() -> Bool
}

public final class LocalAuthDataSourceImpl: LocalAuthDataSource {
    private let keychain: any Keychain

    public init(keychain: any Keychain) {
        self.keychain = keychain
    }

    public func logout() {
        keychain.delete(type: .accessToken)
        keychain.delete(type: .refreshToken)
    }
    
    public func checkIsExistAccessToken() -> Bool {
        let isEmptyAccessToken = keychain.load(type: .accessToken).isEmpty
        return !isEmptyAccessToken
    }
}

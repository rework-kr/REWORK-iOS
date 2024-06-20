import Foundation
import KeychainModule
import Moya
import RxMoya
import RxSwift

open class BaseRemoteDataSource<API: RWAPI> {
    private let keychain: any Keychain
    private let provider: MoyaProvider<API>
    private let decoder = JSONDecoder()
    private let maxRetryCount = 2

    public init(
        keychain: any Keychain,
        provider: MoyaProvider<API>? = nil
    ) {
        self.keychain = keychain
        #if DEBUG
        self.provider = provider ?? MoyaProvider(plugins: [JwtPlugin(keychain: keychain), CustomLoggingPlugin()])
        #else
            self.provider = provider ?? MoyaProvider(plugins: [JwtPlugin(keychain: keychain)])
        #endif
    }

    public func request(_ api: API) -> Single<Response> {
        return Single<Response>.create { single in
            var disposabels = [Disposable]()
            disposabels.append(
                self.defaultRequest(api).subscribe(
                    onSuccess: { single(.success($0)) },
                    onFailure: { single(.failure($0)) }
                )
            )
            return Disposables.create(disposabels)
        }
    }
}

private extension BaseRemoteDataSource {
    func defaultRequest(_ api: API) -> Single<Response> {
        return provider.rx.request(api)
            .timeout(.seconds(10), scheduler: MainScheduler.asyncInstance)
            .catch { error in
                guard let errorCode = (error as? MoyaError)?.response?.statusCode else {
                    if let moyaError = (error as? MoyaError), moyaError.errorCode == 6 {
                        return Single.error(api.errorMap[1009] ?? error)
                    }
                    return Single.error(error)
                }
                return Single.error(api.errorMap[errorCode] ?? error)
            }
    }
}

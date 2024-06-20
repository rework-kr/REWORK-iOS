import ErrorModule
import Foundation
import KeychainModule
import Moya
import Utility

public protocol RWAPI: TargetType {
    var domain: RWDomain { get }
    var urlPath: String { get }
    var errorMap: [Int: RWError] { get }
}

public extension RWAPI {
    var baseURL: URL {
        URL(string: BASE_URL())!
    }

    var path: String {
        domain.asURLString + urlPath
    }

    var headers: [String: String]? {
        ["Content-Type": "application/json"]
    }

    var validationType: ValidationType {
        return .successCodes
    }
}

public enum RWDomain: String {
    case auth
    case dailyAgenda
    case monthlyAgenda
}

extension RWDomain {
    var asURLString: String {
        "/\(self.asDomainString)"
    }
}

extension RWDomain {
    var asDomainString: String {
        switch self {
        case .auth:
            return RWDOMAIN_AUTH()
        case .dailyAgenda:
            return RWDOMAIN_DAILY_AGENDA()
        case .monthlyAgenda:
            return RWDOMAIN_MONTHLY_AGENDA()
        }
    }
}

import BaseDomain
import ErrorModule
import Foundation
import Moya

public enum AuthAPI {
    case resetPassword(userId: String, oldPassword: String, newPassword: String)
    case reGenerateAccessToken
    case signUp(email: String)
    case logout
    case userInfo
}

private struct ResetPasswordRequestParameters: Encodable {
    let userId: String
    let oldPassword: String
    let newPassword: String
}

private struct FetchTokenRequestParameters: Encodable {
    var provider: String
    var token: String
}

private struct SignUpRequestParameters: Encodable {
    let email: String
}

extension AuthAPI: RWAPI {
    public var baseURL: URL {
        return URL(string: BASE_URL())!
    }

    public var domain: RWDomain {
        return .auth
    }

    public var urlPath: String {
        switch self {
        case .resetPassword:
            return "/password"
        case .reGenerateAccessToken:
            return "/renew-access-token"
        case .signUp:
            return "/register-email"
        case .logout:
            return "/logout"
        case .userInfo:
            return "/info"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .resetPassword:
            return .put
        case .reGenerateAccessToken:
            return .post
        case .signUp:
            return .post
        case .logout:
            return .post
        case .userInfo:
            return .get
        }
    }

    public var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }

    public var task: Moya.Task {
        switch self {
        case let .resetPassword(userId, oldPassword, newPassword):
            let queryParams: [String: Any] = ["securityUtils": ""]
            let bodyParams: [String: Any] = [
                "userId": userId,
                "oldPassword": oldPassword,
                "newPassword": newPassword
            ]
            return .requestCompositeParameters(bodyParameters: bodyParams, bodyEncoding: JSONEncoding(), urlParameters: queryParams)
            
        case .reGenerateAccessToken:
            return .requestPlain
        case let .signUp(email):
            return .requestJSONEncodable(SignUpRequestParameters(email: email))
        case .logout:
            return .requestPlain
        case .userInfo:
            let queryParams: [String: Any] = ["securityUtils": ""]
            return .requestParameters(parameters: queryParams, encoding: JSONEncoding())
        }

    }

    public var jwtTokenType: JwtTokenType {
        switch self {
        case .resetPassword:
            return .accessToken
        case .reGenerateAccessToken:
            return .accessToken
        case .signUp:
            return .accessToken
        case .logout:
            return .accessToken
        case .userInfo:
            return .accessToken
        }
    }

    public var errorMap: [Int: RWError] {
        switch self {
        default:
            return [
                400: .badRequest,
                401: .unAuthorized,
                404: .notFound,
                429: .tooManyRequest,
                500: .internalServerError
            ]
        }
    }
}

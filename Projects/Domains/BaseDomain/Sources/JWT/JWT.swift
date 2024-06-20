import Moya

public enum JwtTokenType: String {
    case accessToken
    case refreshToken
    case none

    var headerKey: String {
        switch self {
        case .accessToken, .refreshToken:
            return "Authorization"
        default:
            return ""
        }
    }
}

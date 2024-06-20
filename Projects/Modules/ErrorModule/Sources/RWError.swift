import Foundation

public enum RWError: Error, Equatable {
    case unknown
    case custom(message: String = "알 수 없는 오류가 발생하였습니다", code: Int = 500)
    case badRequest
    case unAuthorized
    case forbidden
    case notFound
    case conflict
    case tooManyRequest
    case internalServerError
    case offline
}

extension RWError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .unknown:
            return "알 수 없는 오류가 발생하였습니다."
        case let .custom(message, _):
            return message
        case .badRequest: // 400
            return "요청이 잘못되었습니다."
        case .unAuthorized: // 401
            return "인증에 실패했습니다"
        case .forbidden: // 403
            return "접근 권한이 없습니다."
        case .notFound: // 404
            return "요청한 것을 찾을 수 없습니다."
        case .conflict: // 409
            return "요청이 이미 존재합니다."
        case .tooManyRequest: // 429
            return "요청 횟수를 초과했습니다.\n잠시 후 다시 시도해주세요!"
        case .internalServerError: // 500
            return "서버에서 문제가 발생하였습니다.\n잠시 후 다시 시도해주세요!"
        case .offline: // 1009
            return "인터넷 연결이 오프라인입니다.\n네트워크 상태를 확인해주세요."
        }
    }
}

public extension Error {
    var asWRWrror: RWError {
        self as? RWError ?? .unknown
    }
}

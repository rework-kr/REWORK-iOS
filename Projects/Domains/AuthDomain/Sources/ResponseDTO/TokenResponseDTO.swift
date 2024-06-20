import Foundation

public struct TokenResponseDTO: Decodable {
    public let accessToken: String
}

public extension TokenResponseDTO {
    func toDomain() -> TokenEntity {
        TokenEntity(accessToken: accessToken)
    }
}

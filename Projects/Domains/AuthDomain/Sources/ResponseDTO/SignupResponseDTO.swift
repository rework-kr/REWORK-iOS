import Foundation

public struct SignupResponseDTO: Decodable {
    public let code: Int
    public let message: String

}

public extension SignupResponseDTO {
    func toDomain() -> SignUpEntity {
        SignUpEntity()
    }
}

import Foundation

public struct ResetPasswordResponseDTO: Decodable {
    public let userId: String
    public let oldPassword: String
    public let newPassword: String

}

public extension ResetPasswordResponseDTO {
    func toDomain() -> ResetPasswordEntity {
        ResetPasswordEntity(userId: userId, oldPassword: oldPassword, newPassword: newPassword)
    }
}

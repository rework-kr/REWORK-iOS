import Foundation

public struct UserInfoResponseDTO: Decodable {
    public let code: Int
    public let message: String

}

public extension UserInfoResponseDTO {
    func toDomain() -> UserInfoEntity {
        UserInfoEntity(name: "임시닉네임")
    }
}

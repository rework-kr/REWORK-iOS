import UIKit

public struct AgendaInfo: Codable {
    public let title: String
    
    public init(title: String) {
        self.title = title
    }
}

import UIKit
import DesignSystem
import SnapKit
import Then

public struct AgendaSectionItem: Hashable, Equatable {
    public let title: String
    public let identifier = UUID()

    public init(title: String) {
        self.title = title
    }
}

public extension AgendaSectionItem {
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }

    static func == (lhs: AgendaSectionItem, rhs: AgendaSectionItem) -> Bool {
        lhs.identifier == rhs.identifier
    }
}

import UIKit
import DesignSystem
import SnapKit
import Then

public struct AgendaSectionItem: Hashable, Equatable {
    public let index: Int
    public let title: String
    
    public init(index: Int, title: String) {
        self.index = index
        self.title = title
    }
}

public extension AgendaSectionItem {
    func hash(into hasher: inout Hasher) {
        hasher.combine(index)
        hasher.combine(title)
    }

    static func == (lhs: AgendaSectionItem, rhs: AgendaSectionItem) -> Bool {
        lhs.index == rhs.index && lhs.title == rhs.title
    }
}

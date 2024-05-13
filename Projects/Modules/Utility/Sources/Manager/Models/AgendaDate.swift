import UIKit

public struct AgendaDate: Equatable, Hashable, Codable {
    let year: Int
    let month: Int
    let day: Int
    
    init(year: Int, month: Int, day: Int) {
        self.year = year
        self.month = month
        self.day = day
    }
    
}

public extension AgendaDate {
    func hash(into hasher: inout Hasher) {
        hasher.combine(year)
        hasher.combine(month)
        hasher.combine(day)
    }
}

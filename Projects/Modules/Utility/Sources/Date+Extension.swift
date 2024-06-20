import Foundation

public extension Date {
    func year() -> Int {
        let calendar = Calendar.current
        return calendar.component(.year, from: self)
    }
    
    func month() -> Int {
        let calendar = Calendar.current
        return calendar.component(.month, from: self)
    }
    
    func day() -> Int {
        let calendar = Calendar.current
        return calendar.component(.day, from: self)
    }
    
}

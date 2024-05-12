import Foundation

public extension Collection {
    subscript(safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

public extension Sequence where Element: Equatable {
    var uniqueElements: [Element] {
        return self.reduce(into: []) { uniqueElements, element in
            if !uniqueElements.contains(element) {
                uniqueElements.append(element)
            }
        }
    }
}

import Foundation

// MARK: - PathEquatable

public protocol PathEquatable: Equatable {
    associatedtype EquatableProperty: Equatable
    static var equatablePath: KeyPath<Self, EquatableProperty> { get }
}

public extension PathEquatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs[keyPath: equatablePath] == rhs[keyPath: equatablePath]
    }
}

// MARK: - PathComparable

public protocol PathComparable: Comparable, PathEquatable where EquatableProperty == ComparableProperty {
    associatedtype ComparableProperty: Comparable
    static var comparablePath: KeyPath<Self, ComparableProperty> { get }
}

public extension PathComparable {
    static var equatablePath: KeyPath<Self, EquatableProperty> {
        comparablePath
    }
    
    static func < (lhs: Self, rhs: Self) -> Bool {
        lhs[keyPath: comparablePath] < rhs[keyPath: comparablePath]
    }
    
    static func > (lhs: Self, rhs: Self) -> Bool {
        lhs[keyPath: comparablePath] > rhs[keyPath: comparablePath]
    }
}

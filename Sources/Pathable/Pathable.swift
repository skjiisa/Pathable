//
//  Pathable.swift
//  Pathable
//
//  Created by Elaine Lyons on 4/8/23.
//

import Foundation

// MARK: - PathEquatable

/// A type that conforms to
/// [`Equatable`](https://developer.apple.com/documentation/swift/equatable)
/// using an `Equatable` property at a specified key path for equality checks.
///
/// `PathEquatable` allows for easy conformance to `Equatable` by simply
/// specifying an `Equatable` property to be used for equality checks. For example:
///
/// ```swift
/// struct Person {
///     let name: String
///     var action: () -> Void = { }
/// }
/// ```
///
/// `Person` contains the `action` closure property which itself cannot be
/// `Equatable`, making it so that `Equatable` conformance would require
/// explicit implementation of `==(lhs:rhs:)`. If we want to make `Person`
/// conform to `Equatable` by just checking the `name`, ignoring the action,
/// we can do so by conforming to `PathEquatable` and specifying the
/// `equatablePath`:
///
/// ```swift
/// struct Person: PathEquatable {
///     static let equatablePath = \Self.name
///     let name: String
///     let action: () -> Void = { }
/// }
/// ```
///
/// Now any two `Person` instances with the same name will be considered equal.
///
/// ```swift
/// Person(name: "Ember", action: { }) == Person(name: "Ember", action: { print(name) }) // true
/// ```
public protocol PathEquatable: Equatable {
    /// The type of the property used for equality checks.
    /// Inferred if the property itself is a `let`.
    associatedtype EquatableProperty: Equatable
    
    /// The key path for the
    /// [`Equatable`](https://developer.apple.com/documentation/swift/equatable)
    /// property to use for the type's `Equatable` conformance.
    static var equatablePath: KeyPath<Self, EquatableProperty> { get }
}

public extension PathEquatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs[keyPath: equatablePath] == rhs[keyPath: equatablePath]
    }
}

// MARK: - PathComparable

/// A type that conforms to
/// [`Comparable`](https://developer.apple.com/documentation/swift/comparable)
/// using a `Comparable` property at a specified key path for comparisons.
///
/// `PathComparable` allows for easy conformance to `Comparable` by simply
/// specifying a `Comparable` property to be used for comparisons. For example:
///
/// ```swift
/// struct Person {
///     let name: String
///     var action: () -> Void = { }
/// }
/// ```
///
/// `Person` contains the `action` closure property which itself cannot be
/// `Comparable`, making it so that `Comparable` conformance would require
/// explicit implementation of `<(lhs:rhs:)` and `Equatable` conformance.
/// If we want to make `Person` conform to `Comparable` by just comparing
/// the `name`, ignoring the action, we can do so by conforming to
/// `PathComparable` and specifying the `comparablePath`:
///
/// ```swift
/// struct Person: PathEquatable {
///     static let comparablePath = \Self.name
///     let name: String
///     let action: () -> Void = { }
/// }
///
/// Person(name: "A") > Person("B") // true
/// Person(name: "A") < Person("B") // false
/// ```
///
/// Conforming to `PathComparable` brings automatic conformance to ``PathEquatable``.
public protocol PathComparable: Comparable, PathEquatable where EquatableProperty == ComparableProperty {
    /// The type of the property used for comparison checks.
    /// Inferred if the property itself is a `let`.
    associatedtype ComparableProperty: Comparable
    
    /// The key path for the
    /// [`Comparable`](https://developer.apple.com/documentation/swift/comparable)
    /// property to use for the type's `Comparable` conformance.
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

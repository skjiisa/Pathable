//
//  Sorting.swift
//  Pathable
//
//  Created by Elaine Lyons on 4/8/23.
//

import Foundation

// MARK: - Sequence+Sorted

public extension Sequence {
    /// Returns the elements of the array, sorted by the value
    /// of the property at a specified key path.
    ///
    /// Use this method to sort an array of elements by the value
    /// of a specific property. The elements in the resulting array
    /// are sorted in ascending order, as determined by the
    /// `Comparable` conformance of the property's value type.
    ///
    /// ```swift
    /// struct Person {
    ///     var name: String
    ///     var age: Int
    /// }
    ///
    /// let people = [Person(name: "Alice", age: 30), Person(name: "Cait", age: 35), Person(name: "Beatrice", age: 25)]
    ///
    /// let sortedByName = people.sorted(path: \.name)
    /// // sortedByName == [Person(name: "Alice", age: 30), Person(name: "Beatrice", age: 25), Person(name: "Cait", age: 35)]
    ///
    /// let sortedByAge = people.sorted(path: \.age)
    /// // sortedByAge == [Person(name: "Beatrice", age: 25), Person(name: "Alice", age: 30), Person(name: "Cait", age: 35)]
    /// ```
    ///
    /// - Parameter path: The key path of the property to sort by.
    /// - Returns: A array of the sequence’s elements sorted by a given property.
    /// - Complexity: O(n log n), where n is the length of the collection.
    func sorted<Value>(
        path: KeyPath<Self.Element, Value>
    ) -> [Self.Element] where Value: Comparable {
        self.sorted { lhs, rhs in
            lhs[keyPath: path] < rhs[keyPath: path]
        }
    }
    
    /// Returns the elements of the array, sorted by the value of the property
    /// at a specified key path using the given predicate.
    ///
    /// Use this method to sort an array of elements by the value of a specific
    /// property using a custom predicate. The elements in the resulting array
    /// are sorted according to the predicate, which takes two values of the
    /// property's value type and returns a `Bool` indicating whether they
    /// are in increasing order.
    ///
    /// ```swift
    /// struct Person {
    ///     var name: String
    ///     var age: Int
    /// }
    ///
    /// let people = [Person(name: "Alice", age: 30), Person(name: "Beatrice", age: 25), Person(name: "Cait", age: 35)]
    ///
    /// let sortedByNameDescending = people.sorted(path: \.name, by: >)
    /// // sortedByNameDescending == [Person(name: "Cait", age: 35), Person(name: "Beatrice", age: 25), Person(name: "Alice", age: 30)]
    ///
    /// let sortedByAgeDescending = people.sorted(path: \.age, by: >)
    /// // sortedByAgeDescending == [Person(name: "Cait", age: 35), Person(name: "Alice", age: 30), Person(name: "Beatrice", age: 25)]
    /// ```
    ///
    /// - Parameters:
    ///   - path: The key path of the property to sort by.
    ///   - areInIncreasingOrder: A predicate that returns `true` if its first
    /// argument should be ordered before its second argument; otherwise, `false`.
    /// - Returns: A array of the sequence’s elements sorted by a given property.
    /// - Complexity: O(n log n), where n is the length of the collection.
    func sorted<Value>(
        path: KeyPath<Self.Element, Value>,
        by areInIncreasingOrder: (Value, Value) throws -> Bool
    ) rethrows -> [Self.Element] {
        try self.sorted { lhs, rhs in
            try areInIncreasingOrder(lhs[keyPath: path], rhs[keyPath: path])
        }
    }
}

// MARK: - Array+Sort

public extension Array {
    /// Sorts the collection in place, using the value of the
    /// property at a specified key path as the sort key.
    ///
    /// This method uses the value of the specified key path to sort the elements
    /// of the collection in ascending order. For example, if the collection contains
    /// instances of a `Person` struct, you can sort the collection by a person's
    /// name property like so:
    ///
    /// ```swift
    /// struct Person {
    ///     var name: String
    ///     var age: Int
    /// }
    ///
    /// var people = [Person(name: "Cait", age: 35), Person(name: "Alice", age: 30), Person(name: "Beatrice", age: 25)]
    ///
    /// people.sort(path: \.name)
    /// // people == [Person(name: "Alice", age: 30), Person(name: "Beatrice", age: 25), Person(name: "Cait", age: 35)]
    ///
    /// people.sort(path: \.age)
    /// // people == [Person(name: "Beatrice", age: 25), Person(name: "Alice", age: 30), Person(name: "Cait", age: 35)]
    /// ```
    ///
    /// - Parameter path: The key path of the property to use as the sort key.
    /// - Complexity: O(*n* log *n*) where *n* is the length of the collection.
    mutating func sort<Value>(
        path: KeyPath<Self.Element, Value>
    ) where Value: Comparable {
        self.sort { lhs, rhs in
            lhs[keyPath: path] < rhs[keyPath: path]
        }
    }
    
    /// Sorts the elements of the collection in place, using the value
    /// of the property at a specified key path as the sort key using a
    /// custom predicate as the comparison between elements.
    ///
    /// This method uses the value of the specified key path to sort the elements
    /// of the collection, and the given predicate to determine the order of elements.
    /// For example, if the collection contains instances of a `Person` struct, you
    /// can sort the collection by a person's age property like so:
    ///
    /// ```swift
    /// struct Person {
    ///     var name: String
    ///     var age: Int
    /// }
    ///
    /// var people = [Person(name: "Cait", age: 35), Person(name: "Beatrice", age: 25), Person(name: "Alice", age: 30)]
    ///
    /// people.sort(path: \.age, by: >)
    /// // people == [Person(name: "Cait", age: 35), Person(name: "Beatrice", age: 25), Person(name: "Alice", age: 30)]
    ///
    /// people.sort(path: \.age, by: >)
    /// // people == [Person(name: "Cait", age: 35), Person(name: "Alice", age: 30), Person(name: "Beatrice", age: 25)]
    /// ```
    ///
    /// - Parameters:
    ///   - path: A key path that indicates the property to use as the sort key.
    ///   - areInIncreasingOrder: A predicate that returns `true` if its first argument
    /// should be ordered before its second argument; otherwise, `false`.
    /// - Complexity: O(*n* log *n*) where *n* is the length of the collection.
    mutating func sort<Value>(
        path: KeyPath<Self.Element, Value>,
        by areInIncreasingOrder: (Value, Value) throws -> Bool
    ) rethrows {
        try self.sort { lhs, rhs in
            try areInIncreasingOrder(lhs[keyPath: path], rhs[keyPath: path])
        }
    }
}


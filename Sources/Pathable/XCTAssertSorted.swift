//
//  XCTAssertSorted.swift
//  Pathable
//
//  Created by Elaine Lyons on 4/8/23.
//

import XCTest

// MARK: Internal Typealiases

internal typealias Assertion = (_ expression: @autoclosure () throws -> Bool, _ message: @autoclosure () -> String, _ file: StaticString, _ line: UInt) -> Void
internal typealias LessThanOrEqualAssertion<T: Comparable> = (_ expression1: @autoclosure () throws -> T, _ expression2: @autoclosure () throws -> T, _ message: @autoclosure () -> String, _ file: StaticString, _ line: UInt) -> Void

// MARK: - Comparable Elements

/// Asserts that a sequence is sorted.
/// - Parameters:
///   - sequence: The sequence to check.
///   - file: The file where the failure occurs.
///   The default is the filename of the test case where you call this function.
///   - line: The line number where the failure occurs.
///   The default is the line number where you call this function.
public func XCTAssertSorted<S: Sequence>(
    _ sequence: S,
    file: StaticString = #file,
    line: UInt = #line
) where S.Element: Comparable {
    XCTAssertSorted(sequence, file: file, line: line, assertion: XCTAssertLessThanOrEqual)
}

/// Use ``XCTAssertSorted(_:file:line:)``
///
/// This internal function exists to support an injectable `LessThanOrEqualAssertion`
/// for the sake of testing the functionality of this assertion function itself.
internal func XCTAssertSorted<S: Sequence>(
    _ sequence: S,
    file: StaticString = #file,
    line: UInt = #line,
    assertion assert: LessThanOrEqualAssertion<S.Element>
) where S.Element: Comparable {
    zip(sequence, sequence.dropFirst()).forEach { lhs, rhs in
        assert(lhs, rhs, "", file, line)
    }
}

// MARK: Closure

/// Asserts that a sequence is sorted using a custom
/// predicate as the comparison between elements.
/// - Parameters:
///   - sequence: The sequence to check.
///   - file: The file where the failure occurs. The default is the filename of the test case where you call this function.
///   - line: The line number where the failure occurs. The default is the line number where you call this function.
///   - areInIncreasingOrder: A predicate that returns `true` if its first
/// argument should be ordered before its second argument; otherwise, `false`.
public func XCTAssertSorted<S: Sequence>(
    _ sequence: S,
    file: StaticString = #file,
    line: UInt = #line,
    by areInIncreasingOrder: (S.Element, S.Element) throws -> Bool
) rethrows {
    try XCTAssertSorted(sequence, file: file, line: line, assertion: XCTAssert, by: areInIncreasingOrder)
}

/// Use ``XCTAssertSorted(_:file:line:by:)``
///
/// This internal function exists to support an injectable `Assertion`
/// for the sake of testing the functionality of this assertion function itself.
internal func XCTAssertSorted<S: Sequence>(
    _ sequence: S,
    file: StaticString = #file,
    line: UInt = #line,
    assertion assert: Assertion,
    by areInIncreasingOrder: (S.Element, S.Element) throws -> Bool
) rethrows {
    try zip(sequence, sequence.dropFirst()).forEach { lhs, rhs in
        let sorted = try areInIncreasingOrder(lhs, rhs)
        assert(sorted, "", file, line)
    }
}

// MARK: Comparable Key Path

/// Asserts that a sequence is sorted by the value of the property at a given key path.
/// - Parameters:
///   - sequence: The sequence to check.
///   - path: The key path of the property it should be sorted by.
///   - file: The file where the failure occurs. The default is the filename of the test case where you call this function.
///   - line: The line number where the failure occurs. The default is the line number where you call this function.
public func XCTAssertSorted<S: Sequence, Value>(
    _ sequence: S,
    path: KeyPath<S.Element, Value>,
    file: StaticString = #file,
    line: UInt = #line
) where Value: Comparable {
    XCTAssertSorted(sequence, path: path, file: file, line: line, assertion: XCTAssertLessThanOrEqual)
}

/// Use ``XCTAssertSorted(_:path:file:line:)``
///
/// This internal function exists to support an injectable `LessThanOrEqualAssertion`
/// for the sake of testing the functionality of this assertion function itself.
internal func XCTAssertSorted<S: Sequence, Value>(
    _ sequence: S,
    path: KeyPath<S.Element, Value>,
    file: StaticString = #file,
    line: UInt = #line,
    assertion assert: LessThanOrEqualAssertion<Value>
) where Value: Comparable {
    zip(sequence, sequence.dropFirst()).forEach { lhs, rhs in
        assert(lhs[keyPath: path], rhs[keyPath: path], "", file, line)
    }
}

// MARK: Key Path Closure

/// Asserts that a sequence is sorted by the value of the property at a given
/// key path using a custom predicate as the comparison between elements.
/// - Parameters:
///   - sequence: The sequence to check.
///   - path: The key path of the property it should be sorted by.
///   - file: The file where the failure occurs. The default is the filename of the test case where you call this function.
///   - line: The line number where the failure occurs. The default is the line number where you call this function.
///   - assert: The underlying XCTest assertion for each comparison.
///   Only used to test this function itself. Defaults to `XCTAssert`.
///   - areInIncreasingOrder: A predicate that returns `true` if its first
/// argument should be ordered before its second argument; otherwise, `false`.
public func XCTAssertSorted<S: Sequence, Value>(
    _ sequence: S,
    path: KeyPath<S.Element, Value>,
    file: StaticString = #file,
    line: UInt = #line,
    by areInIncreasingOrder: (Value, Value) throws -> Bool
) rethrows {
    try XCTAssertSorted(sequence, path: path, file: file, line: line, assertion: XCTAssert, by: areInIncreasingOrder)
}

internal func XCTAssertSorted<S: Sequence, Value>(
    _ sequence: S,
    path: KeyPath<S.Element, Value>,
    file: StaticString = #file,
    line: UInt = #line,
    assertion assert: Assertion,
    by areInIncreasingOrder: (Value, Value) throws -> Bool
) rethrows {
    try zip(sequence, sequence.dropFirst()).forEach { lhs, rhs in
        let sorted = try areInIncreasingOrder(lhs[keyPath: path], rhs[keyPath: path])
        assert(sorted, "", file, line)
    }
}

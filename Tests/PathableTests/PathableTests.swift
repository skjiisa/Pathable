//
//  PathableTests.swift
//  Pathable
//
//  Created by Elaine Lyons on 4/8/23.
//

import XCTest
// Intentionally not using a @testable import to ensure
// implementation is as expected. There are no internal
// entities that need to be tested directly.
import Pathable

final class PathableTests: XCTestCase {
    
    // MARK: - PathEquatable
    
    func testPathEquatable() {
        struct Person: PathEquatable {
            static let equatablePath = \Self.name
            let name: String
            var nonEquatableProperty: () -> Void = { }
        }
        
        let name = UUID().uuidString
        XCTAssertEqual(Person(name: name), Person(name: name))
        XCTAssertNotEqual(Person(name: name), Person(name: UUID().uuidString))
    }
    
    // MARK: - PathComparable
    
    func testPathComparable() {
        struct Person: PathComparable {
            static let comparablePath = \Self.name
            let name: String
            var nonEquatableProperty: () -> Void = { }
        }
        let personA = Person(name: "A")
        let personB = Person(name: "B")
        XCTAssertGreaterThan(personB, personA)
        XCTAssertLessThan(personA, personB)
        XCTAssertEqual(personA, personA)
        XCTAssertEqual(Person.equatablePath, Person.comparablePath)
    }
}

//
//  XCTAssertSortedTests.swift
//  Pathable
//
//  Created by Elaine Lyons on 4/8/23.
//

import XCTest
@testable import Pathable

final class XCTAssertSortedTests: XCTestCase {
    
    // MARK: Item
    
    struct Item {
        var name: String
    }
    
    // MARK: Comparable Elements

    func testComparableCollectionPasses() {
        let sortedArray = ["ABCD", "BCDE", "CDEF", "DEFG"]
        XCTAssertSorted(sortedArray)
    }
    
    func testComparableCollectionFails() {
        let unsortedArray = ["ABCD", "BCDE", "DEFG", "CDEF"]
        
        var failed = false
        let assertion: LessThanOrEqualAssertion<String> = { lhs, rhs, message, _, _ in
            XCTAssert(message().isEmpty)
            do {
                if try lhs() > rhs() {
                    failed = true
                }
            } catch {
                XCTFail("\(error)")
            }
        }
        
        XCTAssertSorted(unsortedArray, assertion: assertion)
        XCTAssertTrue(failed)
    }
    
    // MARK: Closure
    
    func testClosurePasses() {
        let sortedArray = ["DEFG", "CDEF", "BCDE", "ABCD"]
        XCTAssertSorted(sortedArray, by: >)
    }
    
    func testClosureFails() {
        let unsortedArray = ["DEFG", "CDEF", "ABCD", "BCDE"]
        
        var failed = false
        let assertion: Assertion = { expression, message, _, _ in
            XCTAssert(message().isEmpty)
            do {
                if !(try expression()) {
                    failed = true
                }
            } catch {
                XCTFail("\(error)")
            }
        }
        
        XCTAssertSorted(unsortedArray, assertion: assertion, by: >)
        XCTAssertTrue(failed)
    }
    
    // MARK: Comparable Key Path
    
    func testComparableKeyPathsPasses() {
        let sortedArray = [Item(name: "ABCD"), Item(name: "BCDE"), Item(name: "CDEF"), Item(name: "DEFG")]
        XCTAssertSorted(sortedArray, path: \.name)
    }
    
    func testComparableKeyPathsFails() {
        let unsortedArray = [Item(name: "ABCD"), Item(name: "BCDE"), Item(name: "DEFG"), Item(name: "CDEF")]
        
        var failed = false
        let assertion: LessThanOrEqualAssertion<String> = { lhs, rhs, message, _, _ in
            XCTAssert(message().isEmpty)
            do {
                if try lhs() > rhs() {
                    failed = true
                }
            } catch {
                XCTFail("\(error)")
            }
        }
        
        XCTAssertSorted(unsortedArray, path: \.name, assertion: assertion)
        XCTAssertTrue(failed)
    }
    
    // MARK: Key Path Closure
    
    func testKeyPathClosurePasses() {
        let sortedArray = [Item(name: "DEFG"), Item(name: "CDEF"), Item(name: "BCDE"), Item(name: "ABCD")]
        XCTAssertSorted(sortedArray, path: \.name, by: >)
    }
    
    func testKeyPathClosureFails() {
        let unsortedArray = [Item(name: "DEFG"), Item(name: "CDEF"), Item(name: "ABCD"), Item(name: "BCDE")]
        
        var failed = false
        let assertion: Assertion = { expression, message, _, _ in
            XCTAssert(message().isEmpty)
            do {
                if !(try expression()) {
                    failed = true
                }
            } catch {
                XCTFail("\(error)")
            }
        }
        
        XCTAssertSorted(unsortedArray, path: \.name, assertion: assertion, by: >)
        XCTAssertTrue(failed)
    }

}

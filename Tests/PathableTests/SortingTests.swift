//
//  SortingTests.swift
//  Pathable
//
//  Created by Elaine Lyons on 4/8/23.
//

import XCTest
import Pathable

/// Tests the custom `Sequence.sorted` and `Array.sorted` functions.
///
/// Uses custom `XCTAssertSorted` assertions which themselves are tested
/// in `XCTAssertSortedTests.swift`.
final class SortingTests: XCTestCase {
    
    // MARK: Sequence+Sorted
    
    func testSortedByKeyPath() {
        let unsortedArray = [Item(name: "ABCD"), Item(name: "BCDE"), Item(name: "DEFG"), Item(name: "CDEF")]
        let sortedArray = unsortedArray.sorted(path: \.name)
        XCTAssertSorted(sortedArray, path: \.name)
    }
    
    func testSortedByKeyPathUsingClosure() {
        let unsortedArray = [Item(name: "ABCD"), Item(name: "BCDE"), Item(name: "DEFG"), Item(name: "CDEF")]
        let sortedArray = unsortedArray.sorted(path: \.name, by: >)
        XCTAssertSorted(sortedArray, path: \.name, by: >)
    }
    
    // MARK: Array+Sort
    
    func testSortByKeyPath() {
        var array = [Item(name: "ABCD"), Item(name: "BCDE"), Item(name: "DEFG"), Item(name: "CDEF")]
        array.sort(path: \.name)
        XCTAssertSorted(array, path: \.name)
    }
    
    func testSortByKeyPathUsingClosure() {
        var array = [Item(name: "ABCD"), Item(name: "BCDE"), Item(name: "DEFG"), Item(name: "CDEF")]
        array.sort(path: \.name, by: >)
        XCTAssertSorted(array, path: \.name, by: >)
    }
    
    // MARK: Item
    
    struct Item {
        var name: String
    }
    
}

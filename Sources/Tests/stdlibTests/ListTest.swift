//
//  ListTest.swift
//  
//
//  Created by Nikolai Borovennikov on 10.06.2022.
//

import XCTest
import LuaxStdlib

class ListTest: XCTestCase {

    func testLength() throws {
        var array: [NSObject?]? = [1, 2, 3].map { $0 as NSObject }
        let list = List.create(&array)
        XCTAssertEqual(list?.length(), array?.count)
    }

    func testGetSet() throws {
        var array: [NSObject?]? = [1, 2, 3].map { $0 as NSObject }
        let list = List.create(&array)
        do {
            try list?.set(0, 0 as NSObject)
            XCTAssertEqual(0, try list?.get(0) as? Int)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testOutOfBounds() throws {
        var array: [NSObject?]? = [1, 2, 3].map { $0 as NSObject }
        let list = List.create(&array)
        XCTAssertNotNil(list)
        XCTAssertThrowsError(try list?.get(5))
        XCTAssertThrowsError(try list?.get(-1))
        XCTAssertThrowsError(try list?.set(5, 1 as NSObject))
        XCTAssertThrowsError(try list?.set(-1, 1 as NSObject))
        XCTAssertThrowsError(try list?.insert(5, 1 as NSObject))
        XCTAssertThrowsError(try list?.insert(-1, 1 as NSObject))
        XCTAssertThrowsError(try list?.remove(5))
        XCTAssertThrowsError(try list?.remove(-1))
    }

    func testAdd() throws {
        var array: [NSObject?]? = [1, 2, 3].map { $0 as NSObject }
        let list = List.create(&array)
        list?.add(4 as NSObject)
        do {
            let result = try list?.get(3) as? Int
            XCTAssertEqual(4, result)
            XCTAssertEqual(list?.length(), 4)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testInsert() throws {
        var array: [NSObject?]? = [1, 2, 4].map { $0 as NSObject }
        let list = List.create(&array)
        do {
            try list?.insert(1, 2 as NSObject)
            let result = try list?.get(1) as? Int
            XCTAssertEqual(2, result)
        } catch {
            XCTFail(error.localizedDescription)
        }
        XCTAssertEqual(list?.length(), 4)
    }

    func testRemove() throws {
        var array: [NSObject?]? = [1, 2, 2.5, 3].map { $0 as NSObject }
        let list = List.create(&array)
        do {
            try list?.remove(2)
            let result = try list?.get(2) as? Double
            XCTAssertEqual(3, result)
        } catch {
            XCTFail(error.localizedDescription)
        }
        XCTAssertEqual(list?.length(), 3)
    }

    func testClear() throws {
        var array: [NSObject?]? = [1, 2, 3].map { $0 as NSObject }
        let list = List.create(&array)
        list?.clear()
        XCTAssertEqual(list?.length(), 0)
    }

    func testToArray() throws {
        var array: [NSObject?]? = [1, 2, 3].map { $0 as NSObject }
        let list = List.create(&array)
        XCTAssertEqual(list?.toArray(), array)
        list?.add(4 as NSObject)
        XCTAssertNotEqual(list?.toArray(), array)
    }

}

//
//  IntMapTest.swift
//  
//
//  Created by Nikolai Borovennikov on 29.06.2022.
//

import XCTest
import LuaxStdlib

class IntMapTest: XCTestCase {

    func testSetGet() throws {
        let m = int_map()
        m.set(0, "value1" as NSObject)
        m.set(1, "value2" as NSObject)
        m.set(1, "changed value2" as NSObject)
        XCTAssertEqual(m.length(), 2)
        XCTAssertEqual(try? m.get(0) as? String, "value1")
        XCTAssertEqual(try? m.get(1) as? String, "changed value2")
    }

    func testAccessToNonExistingKey() throws {
        let m = int_map()
        XCTAssertEqual(m.length(), 0)

        do {
            let _ = try m.get(2)
            XCTFail("request not existing key should thrown exception")
        } catch {
            print(error)
            XCTAssertEqual(error.localizedDescription, IntMapError.notExists.localizedDescription, "request not existing key should thrown IntMapError.notExists")
        }
    }

    func testContains() throws {
        let m = int_map()
        m.set(0, "value1" as NSObject)
        m.set(1, "value2" as NSObject)
        XCTAssertTrue(m.contains(0))
        XCTAssertTrue(m.contains(1))
        XCTAssertFalse(m.contains(2))
    }

    func testRemove() throws {
        let m = int_map()
        m.set(0, "value1" as NSObject)
        m.set(1, "value2" as NSObject)
        m.remove(0);
        XCTAssertTrue(m.contains(1))
        XCTAssertFalse(m.contains(0))
    }

    func testKeys() throws {
        let m = int_map()
        m.set(0, "value1" as NSObject)
        m.set(1, "value2" as NSObject)
        let keys = m.keys()
        XCTAssertEqual(keys?.count, 2)
        XCTAssert(keys?.contains(0) == true)
        XCTAssert(keys?.contains(1) == true)
    }

    func testClear() throws {
        let m = int_map()
        m.set(0, "value1" as NSObject)
        m.set(1, "value2" as NSObject)
        XCTAssertEqual(m.length(), 2)
        m.clear()
        XCTAssertEqual(m.length(), 0)
    }

}

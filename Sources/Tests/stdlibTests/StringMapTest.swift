//
//  StringMapTest.swift
//  
//
//  Created by Nikolai Borovennikov on 29.06.2022.
//

import XCTest
import LuaxStdlib

class StringMapTest: XCTestCase {

    func testSetGet() throws {
        let m = string_map()
        m.set("key", "value1" as NSObject)
        m.set("key2", "value2" as NSObject)
        m.set("key2", "changed value2" as NSObject)
        XCTAssertEqual(m.length(), 2)
        XCTAssertEqual(try? m.get("key") as? String, "value1")
        XCTAssertEqual(try? m.get("key2") as? String, "changed value2")
    }

    func testAccessToNonExistingKey() throws {
        let m = string_map()
        XCTAssertEqual(m.length(), 0)

        do {
            let _ = try m.get("key3")
            XCTFail("request not existing key should thrown exception")
        } catch {
            print(error)
            XCTAssertEqual(error.localizedDescription, StringMapError.notExists.localizedDescription, "request not existing key should thrown StringMapError.notExists")
        }
    }

    func testContains() throws {
        let m = string_map()
        m.set("key", "value1" as NSObject)
        m.set("key2", "value2" as NSObject)
        XCTAssertTrue(m.contains("key"))
        XCTAssertTrue(m.contains("key2"))
        XCTAssertFalse(m.contains("key3"))
    }

    func testRemove() throws {
        let m = string_map()
        m.set("key", "value1" as NSObject)
        m.set("key2", "value2" as NSObject)
        m.remove("key");
        XCTAssertTrue(m.contains("key2"))
        XCTAssertFalse(m.contains("key"))
    }

    func testKeys() throws {
        let m = string_map()
        m.set("key", "value1" as NSObject)
        m.set("key2", "value2" as NSObject)
        let keys = m.keys()
        XCTAssertEqual(keys?.count, 2)
        XCTAssert(keys?.contains("key") == true)
        XCTAssert(keys?.contains("key2") == true)
    }

    func testClear() throws {
        let m = string_map()
        m.set("key", "value1" as NSObject)
        m.set("key2", "value2" as NSObject)
        XCTAssertEqual(m.length(), 2)
        m.clear()
        XCTAssertEqual(m.length(), 0)
    }

}

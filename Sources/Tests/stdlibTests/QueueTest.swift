//
//  QueueTest.swift
//  
//
//  Created by Nikolai Borovennikov on 06.07.2022.
//

import XCTest
import LuaxStdlib

class QueueTest: XCTestCase {

    func testEnqueue() throws {
        let q = queue()
        XCTAssertEqual(q.length(), 0)
        q.enqueue("a" as NSObject)
        q.enqueue("a" as NSObject)
        q.enqueue("a" as NSObject)
        XCTAssertEqual(q.length(), 3)
    }

    func testPeek() throws {
        let q = queue()
        q.enqueue("a" as NSObject)
        q.enqueue("b" as NSObject)
        q.enqueue("c" as NSObject)
        let element = try q.peek()

        XCTAssertEqual(element as? String, "a")
        XCTAssertEqual(q.length(), 3)
    }

    func testDequeue() throws {
        let q = queue()
        q.enqueue("a" as NSObject)
        q.enqueue("b" as NSObject)
        q.enqueue("c" as NSObject)
        var element: NSObject? = try q.dequeue()

        XCTAssertEqual(element as? String, "a")
        XCTAssertEqual(q.length(), 2)
        element = try q.dequeue()
        XCTAssertEqual(element as? String, "b")
        XCTAssertEqual(q.length(), 1)
    }

    func testClear() throws {
        let q = queue()
        XCTAssertEqual(q.length(), 0)
        q.enqueue("a" as NSObject)
        q.enqueue("b" as NSObject)
        q.enqueue("c" as NSObject)
        XCTAssertEqual(q.length(), 3)

        q.clear()
        XCTAssertEqual(q.length(), 0)
    }

}

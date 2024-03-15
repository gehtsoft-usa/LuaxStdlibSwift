//
//  SchedulerTest.swift
//  
//
//  Created by Nikolai Borovennikov on 22.06.2022.
//

import XCTest
import LuaxStdlib

class SchedulerTest: XCTestCase {

    var expectation: XCTestExpectation!
    var waiter: XCTWaiter!
    var invoker: Invoker!
    var mustBeStopped = false

    class Invoker: action {
        private var expectation: XCTestExpectation
        private(set) var invoked = false
        private(set) var invokeCount = 0
        private(set) var invokeTotal = 0

        init(expectation: XCTestExpectation, cnt: Int) {
            self.expectation = expectation
            self.invokeCount = 0
            self.invokeTotal = cnt
        }

        func invoke() throws {
            invoked = true
            print("Do action: \(Date())")
            invokeCount = invokeCount + 1;
            if invokeCount == invokeTotal {
                expectation.fulfill()
            }
        }
    }

    func testStartImmediately1() throws {
        expectation = expectation(description: "Scheduler: start immediately")
        invoker = Invoker(expectation: expectation, cnt: 1)
        let scheduler = Scheduler.create(500, invoker)
        print("Execute action: \(Date())")
        scheduler?.startImmediately()
        scheduler?.stop()
        waitForExpectations(timeout: 0.0) { error in
            XCTAssertTrue(self.invoker.invoked)
        }
    }

    func testStartImmediately2() throws {
        expectation = expectation(description: "Scheduler: start immediately")
        invoker = Invoker(expectation: expectation, cnt: 3)
        let scheduler = Scheduler.create(1000, invoker)
        print("Execute action: \(Date())")
        scheduler?.startImmediately()
        waitForExpectations(timeout: 2.5) { error in
            XCTAssertTrue(self.invoker.invoked)
        }
        scheduler?.stop()
        XCTAssertEqual(self.invoker.invokeCount, 3, "We should have invoked exactly 3 actions")
    }

    func testWithDelay() throws {
        expectation = expectation(description: "Scheduler: start with delay")
        invoker = Invoker(expectation: expectation, cnt: 2)
        let scheduler = Scheduler.create(1000, invoker)
        print("Schedule action: \(Date())")
        scheduler?.startWithDelay()
        waitForExpectations(timeout: 2.5) { error in
            XCTAssertTrue(self.invoker.invoked)
        }
        scheduler?.stop()
        XCTAssertEqual(self.invoker.invokeCount, 2, "We should have invoked exactly 2 actions")
    }

    func testStartWithDelayAndStop() throws {
        expectation = expectation(description: "Scheduler: start and stop")
        mustBeStopped = true
        invoker = Invoker(expectation: expectation, cnt: 1)
        guard let scheduler = Scheduler.create(1000, invoker) else {
            XCTFail("Can't create scheduler")
            return
        }
        print("Schedule action: \(Date())")
        scheduler.startWithDelay()
        scheduler.stop()

        waiter = XCTWaiter(delegate: self)
        waiter.wait(for: [expectation], timeout: 1.05)
    }

    // MARK: - XCTWaiterDelegate

    override func waiter(
        _ waiter: XCTWaiter,
        didTimeoutWithUnfulfilledExpectations unfulfilledExpectations: [XCTestExpectation]
    ) {
        XCTAssertNotEqual(mustBeStopped, invoker.invoked)
    }

    override func nestedWaiter(
        _ waiter: XCTWaiter,
        wasInterruptedByTimedOutWaiter outerWaiter: XCTWaiter
    ) {
        print("wasInterruptedByTimedOutWaiter")
    }

    override func waiter(
        _ waiter: XCTWaiter,
        fulfillmentDidViolateOrderingConstraintsFor expectation: XCTestExpectation,
        requiredExpectation: XCTestExpectation
    ) {
        print("fulfillmentDidViolateOrderingConstraintsFor")
    }

    override func waiter(
        _ waiter: XCTWaiter,
        didFulfillInvertedExpectation expectation: XCTestExpectation
    ) {
        print("didFulfillInvertedExpectation")
    }

}

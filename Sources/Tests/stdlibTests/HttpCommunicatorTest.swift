//
//  HttpCommunicatorTest.swift
//
//
//  Created by Nikolai Borovennikov on 16.06.2022.
//

import XCTest
import LuaxStdlib

class HttpCommunicatorTest: XCTestCase {

    var expectation: XCTestExpectation?

    func testGet() throws {
        expectation = expectation(description: "HttpCommunicatorTest GET - success")
        let processor = HttpCommunicatorProcessor(
                url: "http://fxcorporate.com",
                expectation: expectation!,
                mustBeSuccesss: true
        )
        try processor.doGetRequest()
        waitForExpectations(timeout: 30) { [weak self] error in
            XCTAssertNil(error)
            self?.expectation = nil
        }
    }

    func testPost() throws {
        expectation = expectation(description: "HttpCommunicatorTest POST - failure")
        let processor = HttpCommunicatorProcessor(
                url: "http://tsqa2.gehtsoft.com:22000/Hosts.jsp",
                expectation: expectation!,
                mustBeSuccesss: false
        )
        processor.set(value: "JSON", forHeader: "Content-type")
        try processor.doPostRequest(body: "{\"value\": \"Test body\"}")
        waitForExpectations(timeout: 30) { [weak self] error in
            XCTAssertNil(error)
            self?.expectation = nil
        }
    }

    func testFailure() throws {
        expectation = expectation(description: "HttpCommunicatorTest GET - failure")
        let processor = HttpCommunicatorProcessor(
                url: "http://fxcorpx2.fxcorporate.com/Hosts.jsp",
                expectation: expectation!,
                mustBeSuccesss: false
        )
        try processor.doGetRequest()
        waitForExpectations(timeout: 30) { [weak self] error in
            XCTAssertNil(error)
            self?.expectation = nil
        }
    }

    func testCancel() throws {
        expectation = expectation(description: "HttpCommunicatorTest GET - cancellation")
        let processor = HttpCommunicatorProcessor(
                url: "http://fxcorpx.fxcorporate.com/Hosts.jsp",
                expectation: expectation!,
                mustBeSuccesss: false
        )
        try processor.doGetRequest()
        try processor.doCancel()
        waitForExpectations(timeout: 30) { [weak self] error in
            XCTAssertNil(error)
            self?.expectation = nil
        }
    }

    func testBadUrl() throws {
        expectation = expectation(description: "HttpCommunicatorTest GET - bad url")
        let processor = HttpCommunicatorProcessor(
                url: "<url port=\"22000\">tsqa.gehtsoft.com</url>",
                expectation: expectation!,
                mustBeSuccesss: false
        )
        try processor.doGetRequest()
        waitForExpectations(timeout: 30) { [weak self] error in
            XCTAssertNil(error)
            self?.expectation = nil
        }
    }

    func testMultipleRequests() throws {
        expectation = expectation(description: "HttpCommunicatorTest GET - multiple requests")
        let processor = HttpCommunicatorMultipleProcessor(expectation: expectation!, requests: [
            TestRequest(
                    url: "http://fxcorpx.fxcorporate.com/Hosts.jsp",
                    body: nil,
                    isGet: true
            ),
            TestRequest(
                    url: "http://fxcorpx2.fxcorporate.com/Hosts.jsp",
                    body: "{\"value\": \"Test body\"}",
                    isGet: false
            ),
            TestRequest(
                    url: "http://fxcorpx3.fxcorporate.com/Hosts.jsp",
                    body: nil,
                    isGet: true
            ),
        ])
        try processor.executeRequests()
        waitForExpectations(timeout: 30) { [weak self] error in
            XCTAssertNil(error)
            self?.expectation = nil
        }
    }

}

class HttpCommunicatorProcessor: httpResponseCallback {

    let communicator: httpCommunicator
    private let url: String
    private var expectation: XCTestExpectation?
    private let mustBeSuccesss: Bool

    init(url: String, expectation: XCTestExpectation, mustBeSuccesss: Bool) {
        communicator = httpCommunicator()
        self.url = url
        self.expectation = expectation
        self.mustBeSuccesss = mustBeSuccesss
    }

    func set(value: String, forHeader header: String) {
        communicator.setRequestHeader(header, value)
    }

    func doGetRequest() throws {
        try communicator.get(url, self)
    }

    func doPostRequest(body: String) throws {
        try communicator.post(url, body, self)
    }

    func doCancel() throws {
        guard let expectation = expectation else { return }
        try communicator.cancel()
        expectation.fulfill()
        self.expectation = nil
    }

    override func onComplete(_ status : Int, _ responseText : String?) {
        guard let expectation = expectation else { return }
        if mustBeSuccesss {
        
            XCTAssertEqual(status, 200)
        } else {
            XCTAssertNotEqual(status, 200)
        }
        expectation.fulfill()
        self.expectation = nil
    }

    override func onError(_ error : String?) {
        guard let expectation = expectation else { return }
        XCTAssertFalse(mustBeSuccesss)
        expectation.fulfill()
        self.expectation = nil
    }

}

struct TestRequest {
    let url: String
    let body: String?
    let isGet: Bool
}

class HttpCommunicatorMultipleProcessor: httpResponseCallback {

    let communicator: httpCommunicator
    private var expectation: XCTestExpectation?
    private var requests: [TestRequest]
    private var responsesCount = 0

    init(expectation: XCTestExpectation, requests: [TestRequest]) {
        communicator = httpCommunicator()
        self.expectation = expectation
        self.requests = requests
    }

    func set(value: String, forHeader header: String) {
        communicator.setRequestHeader(header, value)
    }

    func executeRequests() throws {
        for request in requests {
            if request.isGet {
                try communicator.get(request.url, self)
            } else {
                try communicator.post(request.url, request.body ?? "", self)
            }
        }
    }

    override func onComplete(_ status: Int, _ responseText: String?) {
        responsesCount += 1
        processExpectation()
    }

    override func onError(_ error: String?) {
        responsesCount += 1
        processExpectation()
    }

    private func processExpectation() {
        guard responsesCount == requests.count,
              let expectation = expectation else {
            return
        }
        expectation.fulfill()
        self.expectation = nil
    }

}

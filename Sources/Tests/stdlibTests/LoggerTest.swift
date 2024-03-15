//
//  LoggerTest.swift
//  
//
//  Created by Nikolai Borovennikov on 13.06.2022.
//

import XCTest
import LuaxStdlib



class LoggerTest: XCTestCase {

    func testDebug() throws {
        Logger.debug("debug message")
    }

    func testInfo() throws {
        Logger.info("info message")
    }

    func testWarning() throws {
        Logger.warning("warning message")
    }

    func testError() throws {
        Logger.error("error message")
    }

    func testFatal() throws {
        Logger.fatal("fatal message")
    }

}

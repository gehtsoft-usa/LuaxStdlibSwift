//
//  IoTest.swift
//  
//
//  Created by Nikolai Borovennikov on 04.07.2022.
//

import XCTest
import LuaxStdlib

class IoTest: XCTestCase {

    private let fileManager = FileManager.default
    private var documentDirectoryPath: String!
    private let timestamp = Int(Date().timeIntervalSince1970)

    override func setUpWithError() throws {
        guard let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(
                .documentDirectory,
                .userDomainMask,
                true
        ).first else {
            print("set up failed")
            return
        }
        self.documentDirectoryPath = documentDirectoryPath
        print("\(documentDirectoryPath)/\(timestamp)")
        do {
            try fileManager.createDirectory(atPath: "\(documentDirectoryPath)/\(timestamp)",
                                            withIntermediateDirectories: true)
        } catch {
            print("set up failed: \(error.localizedDescription)")
            return
        }
        fileManager.createFile(atPath: "\(documentDirectoryPath)/\(timestamp)/1", contents: "123".data(using: .utf8))
        fileManager.createFile(atPath: "\(documentDirectoryPath)/\(timestamp)/2", contents: nil)
        print("set up done")
    }

    override func tearDownWithError() throws {
        guard let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(
                .documentDirectory,
                .userDomainMask,
                true
        ).first else {
            print("tear down failed")
            return
        }
        do {
            try fileManager.removeItem(atPath: "\(documentDirectoryPath)/\(timestamp)")
        } catch {
            print("tear down failed: \(error.localizedDescription)")
            return
        }
        print("tear down done")
    }

    func testExist() throws {
        XCTAssertTrue(Io.exists("\(timestamp)"))
        XCTAssertTrue(Io.exists("\(timestamp)/1"))
        XCTAssertTrue(Io.exists("\(timestamp)/2"))
        XCTAssertFalse(Io.exists("\(timestamp)/3"))
    }

    func testSize() throws {
        XCTAssertEqual(try? Io.size("\(timestamp)/1"), 3)
        XCTAssertEqual(try? Io.size("\(timestamp)/2"), 0)
        do {
            let _ = try Io.size("\(timestamp)/3")
            XCTFail()
        } catch {
            print(error)
        }
    }

    func testIsFile() throws {
        do {
            XCTAssertTrue(try Io.isFile("\(timestamp)/1"))
            XCTAssertFalse(try Io.isFile("\(timestamp)"))
            let _ = try Io.isFile("\(timestamp)/3")
            XCTFail()
        } catch {
            print(error)
        }
    }

    func testIsFolder() throws {
        do {
            XCTAssertTrue(try Io.isFolder("\(timestamp)"))
            XCTAssertFalse(try Io.isFolder("\(timestamp)/1"))
            let _ = try Io.isFolder("\(timestamp)/3")
            XCTFail()
        } catch {
            print(error)
        }
    }

    func testFiles() throws {
        do {
            let files = try Io.files("\(timestamp)")
            XCTAssertEqual(files?.count, 2)
            XCTAssert(files?.contains("1") == true)
            XCTAssert(files?.contains("2") == true)
            let _ = try Io.files("\(timestamp)/3")
            XCTFail()
        } catch {
            print(error)
        }
    }

    func testFolders() throws {
        do {
            let files = try Io.folders("")
            XCTAssertGreaterThanOrEqual(files?.count ?? -1, 1)
            XCTAssert(files?.contains("\(timestamp)") == true)
            let _ = try Io.folders("\(timestamp)/3")
            XCTFail()
        } catch {
            print(error)
        }
    }

    func testDelete() throws {
        do {
            try Io.delete("\(timestamp)/1")
            try Io.delete("\(timestamp)")
            try Io.delete("\(timestamp)/1")
            XCTFail()
        } catch {
            print(error)
        }
    }

    func testWriteRead() throws {
        do {
            let result = try Io.readTextFromFile("\(documentDirectoryPath!)/\(timestamp)/1", Io.CP_UTF8)
            XCTAssertEqual(result, "123")
        } catch {
            print(error)
        }
        do {
            try Io.writeTextToFile("\(documentDirectoryPath!)/\(timestamp)/2", "qwerty", Io.CP_ANSI)
            let result = try Io.readTextFromFile("\(documentDirectoryPath!)/\(timestamp)/2", Io.CP_ANSI)
            XCTAssertEqual(result, "qwerty")
        } catch {
            print(error)
        }
        do {
            let _ = try Io.readTextFromFile("\(documentDirectoryPath!)/\(timestamp))/2", 1251)
            XCTFail()
        } catch {
            print(error)
        }
        do {
            try Io.writeTextToFile("\(documentDirectoryPath!)/\(timestamp)/3", "qwerty", Io.CP_ANSI)
            XCTFail()
        } catch {
            print(error)
        }
    }

    func testTemp() throws {
        XCTAssertEqual(NSTemporaryDirectory(), Io.tempFolder())
    }

    func testCombinePath() throws {
        XCTAssertEqual(Io.combinePath("1", "2"), "1/2")
    }

    func testFullPath() throws {
        let fullPath = try Io.fullPath("1")
        XCTAssertEqual(fullPath, "\(fileManager.currentDirectoryPath)/1")
    }

}

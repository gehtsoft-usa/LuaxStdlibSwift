//
//  BufferTest.swift
//  
//
//  Created by Nikolai Borovennikov on 05.07.2022.
//

import XCTest
import LuaxStdlib

class BufferTest: XCTestCase {

    func testLength() throws {
        let buffer = try Buffer.create(10)
        XCTAssertEqual(buffer?.length(), 10)
    }

//    func testGet() throws {
//    }
//
//    func testSet() throws {
//    }
//
//    func testGetInt16() throws {
//    }
//
//    func testSetInt16() throws {
//    }
//
//    func testGetInt32() throws {
//    }
//
//    func testSetInt32() throws {
//    }
//
//    func testGetInt16B() throws {
//    }
//
//    func testSetInt16B() throws {
//    }
//
//    func testGetInt32B() throws {
//    }
//
//    func testSetInt32B() throws {
//    }
//
//    func testGetFloat32() throws {
//    }
//
//    func testSetFloat32() throws {
//    }
//
//    func testGetFloat64() throws {
//    }
//
//    func testSetFloat64() throws {
//    }

    func testSetGetEncodedString() throws {
        let buffer = try buffer.create(10)
        let writtenBytesAnsi = try buffer?.setEncodedString(9, "abcd", Io.CP_ANSI)
        XCTAssertEqual(writtenBytesAnsi, 4)

        var result = try buffer?.getEncodedString(9, 4, Io.CP_ANSI)
        XCTAssertEqual(result, "abcd")

        let writtenBytesUtf8 = try buffer?.setEncodedString(12, "abвг", Io.CP_UTF8)
        XCTAssertEqual(writtenBytesUtf8, 6)

        result = try buffer?.getEncodedString(12, 6, Io.CP_UTF8)
        XCTAssertEqual(result, "abвг")

        do {
            let _ = try buffer?.setEncodedString(-5, "---", Io.CP_UTF8)
            XCTFail()
        } catch {
            print(error)
        }

        do {
            let _ = try buffer?.setEncodedString(100500, "---", Io.CP_UTF8)
            XCTFail()
        } catch {
            print(error)
        }

        do {
            result = try buffer?.getEncodedString(-5, 4, Io.CP_UTF8)
            XCTFail()
        } catch {
            print(error)
        }

        do {
            result = try buffer?.getEncodedString(100500, 4, Io.CP_UTF8)
            XCTFail()
        } catch {
            print(error)
        }
    }

//    func testGetUnicodeString() throws {
//    }
//
//    func testSetUnicodeString() throws {
//    }

    func testGetEncodedStringLength() throws {
        let value = "endereço"

        let lengthUtf8 = try buffer.getEncodedStringLength(value, Io.CP_UTF8)
        XCTAssertEqual(lengthUtf8, 9, "Bytes count in UTF-8")

        let lengthAnsi = try? buffer.getEncodedStringLength(value, Io.CP_ANSI)
        XCTAssertNil(lengthAnsi, "Bytes count in ANSI")
    }

    func testSetBuffer() throws {
        guard let data1 = "aVNBblJEaEhBRnNNSmxr".data(using: .utf8),
              let data2 = "ZUVBU3lmRkJWTmtqSWJJ".data(using: .utf8) else {
            XCTFail()
            return
        }

        let buffer1 = buffer(data: data1)
        buffer1.resize(40)

        let buffer2 = buffer(data: data2)
        let _ = try buffer1.setBuffer(20, buffer2, 0, buffer2.length())

        XCTAssertEqual(try buffer1.getEncodedString(0, buffer1.length(), io.CP_UTF8), "aVNBblJEaEhBRnNNSmxrZUVBU3lmRkJWTmtqSWJJ")

        do {
            let _ = try buffer1.setBuffer(-20, buffer2, 0, buffer2.length())
            XCTFail()
        } catch {
            print(error)
        }

        do {
            let _ = try buffer1.setBuffer(100500, buffer2, 0, buffer2.length())
            XCTFail()
        } catch {
            print(error)
        }
    }

    func testResize() throws {
        let buffer = try Buffer.create(10)

        buffer?.resize(20)
        XCTAssertEqual(buffer?.length(), 20)

        buffer?.resize(7)
        XCTAssertEqual(buffer?.length(), 7)
    }

//    func testCreate() throws {
//    }

    func testToHexString() throws {
        guard let data = "FC Lite".data(using: .utf8) else {
            XCTFail()
            return
        }
        let buffer = Buffer(data: data)
        XCTAssertEqual(buffer.toHexString(), "4643204c697465")
    }

    func testToBase64() throws {
        guard let data = "aVNBblJEaEhBRnNNSmxrZUVBU3lmRkJWTmtqSWJJ".data(using: .utf8) else {
            XCTFail()
            return
        }
        let buffer = Buffer(data: data)
        let encodedString = buffer.toBase64()
        XCTAssertEqual(encodedString, "YVZOQmJsSkVhRWhCUm5OTlNteHJaVVZCVTNsbVJrSldUbXRxU1dKSg==")
    }

    func testFromHexString() throws {
        guard let buffer = try Buffer.fromHexString("4643204c697465") else {
            XCTFail()
            return
        }
        let string = try buffer.getEncodedString(0, buffer.length(), Io.CP_UTF8)
        XCTAssertEqual(string, "FC Lite")

        do {
            let _ = try Buffer.fromHexString("this is not hex string")
            XCTFail()
        } catch {
            print(error)
        }
    }

    func testFromBase64() throws {
        guard let buffer = try Buffer.fromBase64("aVNBblJEaEhBRnNNSmxrZUVBU3lmRkJWTmtqSWJJ") else {
            XCTFail()
            return
        }
        let encodedString = try buffer.getEncodedString(0, buffer.length(), Io.CP_ANSI)
        XCTAssertEqual(encodedString, "iSAnRDhHAFsMJlkeEASyfFBVNkjIbI")
    }
}

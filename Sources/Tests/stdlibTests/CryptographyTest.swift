//
//  CryptographyTest.swift
//  
//
//  Created by Nikolai Borovennikov on 06.07.2022.
//

import XCTest
import LuaxStdlib

class CryptographyTest: XCTestCase {

    func testSHA1() throws {
        guard let data = "42ac2662-f2c5-4df6-9ed0-8ead5b5d037c".data(using: .utf8) else {
            XCTFail()
            return
        }
        let buffer = Buffer(data: data)
        let sha1 = try cryptography.SHA1(buffer)
        let encodedString = sha1?.toHexString()
        XCTAssertEqual(encodedString, "edd835af2d1a709ce793ddd6cc0738c0dd411966")
    }

    func testAES128() throws {
        guard let valueData = Data(base64Encoded: "R04tLRRGREXPDxRKXTrU6FSG0FUKNB1UoeGs7dA2HkQZh4ovCoWqiOEEFXhQCExW") else {
            XCTFail()
            return
        }
        let valueBuffer = Buffer(data: valueData)
        guard let keyData = "DfS2tXbmQaRY15TH".data(using: .utf8) else {
            XCTFail()
            return
        }
        let keyBuffer = Buffer(data: keyData)

        let encodedBuffer = try cryptography.AES128(valueBuffer, keyBuffer, false)
        let encodedString = try encodedBuffer!.getEncodedString(0, encodedBuffer!.length(), io.CP_ANSI)!;
        XCTAssertEqual(encodedString, "B34FD0A69C11E64ADBD153E2B9D982E2B981981E")
    }

    func testDEFLATE() throws {
        let source = "test";
        let sourceBuffer = try buffer.create(buffer.getEncodedStringLength(source, io.CP_ANSI)); 
        try sourceBuffer?.setEncodedString(0, source, io.CP_ANSI);
        let encodedBuffer = try cryptography.DEFLATE(sourceBuffer, true);
        let encodedString = encodedBuffer?.toBase64();
        XCTAssertEqual(encodedString, "eJwrSS0uAQAEXQHB")

        guard let valueData = Data(base64Encoded: "eJwrSS0uAQAEXQHB") else {
            XCTFail()
            return
        }
        let valueBuffer = Buffer(data: valueData)

        let decodedBuffer = try cryptography.DEFLATE(valueBuffer, false)
        let decodedString = try decodedBuffer!.getEncodedString(0, decodedBuffer!.length(), io.CP_ANSI)!;
        XCTAssertEqual(decodedString, "test")
    }

}

//
//  CsvParserTest.swift
//  
//
//  Created by Nikolai Borovennikov on 30.06.2022.
//

import XCTest
import LuaxStdlib

class CsvParserTest: XCTestCase {

    func testSimpleCaseEmptyString() throws {
        let parser = CsvParser()

        let r = try? parser.splitLine("")
        XCTAssertEqual(r?.count, 1)
        XCTAssertEqual(r?[0], "")
    }

    func testSimpleCaseOneValue() throws {
        let parser = CsvParser()

        let r = try? parser.splitLine("123")
        XCTAssertEqual(r?.count, 1)
        XCTAssertEqual(r?[0], "123")
    }

    func testSimpleCaseLastValueExists() throws {
        let parser = CsvParser()

        let r = try? parser.splitLine("1,abc,456.6")
        XCTAssertEqual(r?.count, 3)
        XCTAssertEqual(r?[0], "1")
        XCTAssertEqual(r?[1], "abc")
        XCTAssertEqual(r?[2], "456.6")
    }

    func testSimpleCaseLastValueNotExists() throws {
        let parser = CsvParser()

        let r = try? parser.splitLine("1,abc,456.6,")
        XCTAssertEqual(r?.count, 4)
        XCTAssertEqual(r?[0], "1")
        XCTAssertEqual(r?[1], "abc")
        XCTAssertEqual(r?[2], "456.6")
        XCTAssertEqual(r?[3], "")
    }

    func testCommentsDisabled() throws {
        let parser = CsvParser()
        parser.allowComments = false
        parser.commentPrefix = "--"

        let r = try? parser.splitLine("--1,2")
        XCTAssertEqual(r?.count, 2)
        XCTAssertEqual(r?[0], "--1")
        XCTAssertEqual(r?[1], "2")
    }

    func testCommentsEnabled() throws {
        let parser = CsvParser()
        parser.allowComments = true
        parser.commentPrefix = "--"

        let r = try? parser.splitLine("--1,2")
        XCTAssertNil(r)
    }

    func testSimpleCaseCustomSeparator() throws {
        let parser = CsvParser()
        parser.valueSeparator = ";"

        let r = try? parser.splitLine("1;abc;456.6")
        XCTAssertEqual(r?.count, 3)
        XCTAssertEqual(r?[0], "1")
        XCTAssertEqual(r?[1], "abc")
        XCTAssertEqual(r?[2], "456.6")
    }

    func testStringsDisabled() throws {
        let parser = CsvParser()

        let r = try? parser.splitLine("\"1,abc\",456.6")
        XCTAssertEqual(r?.count, 3)
        XCTAssertEqual(r?[0], "\"1")
        XCTAssertEqual(r?[1], "abc\"")
        XCTAssertEqual(r?[2], "456.6")
    }

    func testWrongSeparator() throws {
        let parser = CsvParser()

        parser.valueSeparator = ""
        do {
            let _ = try parser.splitLine("123,456")
            XCTFail()
        } catch {
            print(error.localizedDescription)
            XCTAssertEqual(error.localizedDescription, CsvParserError.wrongValueSeparator.localizedDescription)
        }

        parser.valueSeparator = ";;"
        do {
            let _ = try parser.splitLine("123;456")
            XCTFail()
        } catch {
            print(error.localizedDescription)
            XCTAssertEqual(error.localizedDescription, CsvParserError.wrongValueSeparator.localizedDescription)
        }
    }

/*
    func testParseFile() throws {
        guard let url = Bundle.module.url(
            forResource: "get_all_instruments(139)(USD_Base)",
            withExtension: "csv"
        ) else {
            XCTFail("Can't get file url")
            return
        }
        guard let data = try? Data(contentsOf: url),
              let string = String(data: data, encoding: .utf8) else {
            XCTFail("Can't read file content")
            return
        }

        let parser = CsvParser()
        parser.valueSeparator = "\n"
        guard let r = try parser.splitLine(string) else {
            XCTFail("Can't split string")
            return
        }
        print("Number of lines = \(r.count)")
        for i in 0..<r.count {
            print("\(i): «\(r[i])»")
        }

    }
*/
}

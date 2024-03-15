//
//  StdLibTest.swift
//  
//
//  Created by Nikolai Borovennikov on 13.06.2022.
//

import XCTest
import LuaxStdlib



class StdLibTest: XCTestCase {

    func testLen() throws {
        let string = "string"
        let length = stdlib.len(string)
        XCTAssertEqual(6, length, "length result expected '6' but found '\(length)'")
    }

    func testIndexOf() throws {
        var v = stdlib.indexOf("string_string", "i", true)
        XCTAssertEqual(v, 3, "length result expected '3' but found '\(v)'")

        v = stdlib.indexOf("STRING_STRING", "I", true)
        XCTAssertEqual(v, 3, "indexOf result expected '3' but found '\(v)'")

        v = stdlib.indexOf("string_string", "I", true)
        XCTAssertEqual(v, -1, "indexOf result expected '-1' but found '\(v)'")

        v = stdlib.indexOf("string_string", "I", false)
        XCTAssertEqual(v, 3, "indexOf result expected '3' but found '\(v)'")
    }

    func testLastIndexOf() throws {
        var v = stdlib.lastIndexOf("string_string", "i", true)
        XCTAssertEqual(v, 10, "length result expected '10' but found '\(v)'")

        v = stdlib.lastIndexOf("STRING_STRING", "I", true)
        XCTAssertEqual(v, 10, "indexOf result expected '10' but found '\(v)'")

        v = stdlib.lastIndexOf("string_string", "I", true)
        XCTAssertEqual(v, -1, "indexOf result expected '-1' but found '\(v)'")

        v = stdlib.lastIndexOf("string_string", "I", false)
        XCTAssertEqual(v, 10, "indexOf result expected '10' but found '\(v)'")
    }

    func testCompareStrings() throws {
        var v = stdlib.compareStrings("Aaa", "aaa", true)
        XCTAssertEqual(v, -1, "indexOf result expected '-1' but found '\(v)'")

        v = stdlib.compareStrings("aaa", "aaa", true)
        XCTAssertEqual(v, 0, "indexOf result expected '0' but found '\(v)'")

        v = stdlib.compareStrings("aaa", "Aaa", true)
        XCTAssertEqual(v, 1, "indexOf result expected '1' but found '\(v)'")

        v = stdlib.compareStrings("aaa", "Aaa", false)
        XCTAssertEqual(v, 0, "indexOf result expected '0' but found '\(v)'")

        v = stdlib.compareStrings("BBB", "aaa", false)
        XCTAssertEqual(v, 1, "indexOf result expected '1' but found '\(v)'")

        v = stdlib.compareStrings("BBB", "aaa", true)
        XCTAssertEqual(v, -1, "indexOf result expected '-1' but found '\(v)'")
    }

    func testCharIndex() throws {
        var v = stdlib.charIndex("baba", 97, 0, true) // 'a'
        XCTAssertEqual(v, 1)

        v = stdlib.charIndex("baba", 65, 0, true) // 'A'
        XCTAssertEqual(v, -1)

        v = stdlib.charIndex("baba", 65, 0, false) // 'A'
        XCTAssertEqual(v, 1)

        v = stdlib.charIndex("baba", 97, 1, true) // 'a'
        XCTAssertEqual(v, 1)

        v = stdlib.charIndex("baba", 97, 2, true) // 'a'
        XCTAssertEqual(v, 3)

        v = stdlib.charIndex("baba", 99, 0, true) // 'c'
        XCTAssertEqual(v, -1)

        v = stdlib.charIndex("", 99, 0, true) // 'c'
        XCTAssertEqual(v, -1)
    }

    func testLastCharIndex() throws {
        var v = stdlib.lastCharIndex("baba", 97, 0, true) // 'a'
        XCTAssertEqual(v, 3)

        v = stdlib.lastCharIndex("baba", 65, 0, true) // 'A'
        XCTAssertEqual(v, -1)

        v = stdlib.lastCharIndex("baba", 65, 0, false) // 'A'
        XCTAssertEqual(v, 3)

        v = stdlib.lastCharIndex("baba", 97, 1, true) // 'a'
        XCTAssertEqual(v, 3)

        v = stdlib.lastCharIndex("baba", 97, 2, true) // 'a'
        XCTAssertEqual(v, 3)

        v = stdlib.lastCharIndex("baba", 99, 0, true) // 'c'
        XCTAssertEqual(v, -1)

        v = stdlib.lastCharIndex("", 99, 0, true) // 'c'
        XCTAssertEqual(v, -1)
    }

    func testUpperLower() throws {
        XCTAssertEqual(stdlib.upper("x"), "X")
        XCTAssertEqual(stdlib.upper("asdQWE"), "ASDQWE")
        XCTAssertEqual(stdlib.upper("Aaa bbb"), "AAA BBB")

        XCTAssertEqual(stdlib.lower("X"), "x")
        XCTAssertEqual(stdlib.lower("asdQWE"), "asdqwe")
        XCTAssertEqual(stdlib.lower("Aaa bbb"), "aaa bbb")
    }

    func testLeftRight() throws {
        XCTAssertEqual(stdlib.left("Qwerty", 3), "Qwe")
        XCTAssertEqual(stdlib.right("Qwerty", 3), "rty")

        XCTAssertEqual(stdlib.left("😀 Qwerty 😀", 3), "😀 Q")
        XCTAssertEqual(stdlib.right("😀 Qwerty 😀", 3), "y 😀")
    }

    func testSubstring() throws {
        XCTAssertEqual(stdlib.substring("😀 Qwerty 😀", 0, 2), "😀 ")
        XCTAssertEqual(stdlib.substring("😀 Qwerty 😀", 2, 6), "Qwerty")

        XCTAssertEqual(stdlib.substring("😀 Qwerty 😀", -5, 3), "😀 Q")
        XCTAssertEqual(stdlib.substring("😀 Qwerty 😀", 12, 2), "")
        XCTAssertEqual(stdlib.substring("😀 Qwerty 😀", 8, 50), " 😀")
    }

    func testTrim() throws {
        XCTAssertEqual(stdlib.trim("   Qwerty\t"), "Qwerty")
        XCTAssertEqual(stdlib.trim(" Qwerty "), "Qwerty")
        XCTAssertEqual(stdlib.trim("\nQwerty\n"), "Qwerty")
    }

    func testRtrim() throws {
        XCTAssertEqual(stdlib.rtrim("   Qwerty\t"), "   Qwerty")
        XCTAssertEqual(stdlib.rtrim(" Qwerty "), " Qwerty")
    }

    func testLtrim() throws {
        XCTAssertEqual(stdlib.ltrim("   Qwerty\t"), "Qwerty\t")
        XCTAssertEqual(stdlib.ltrim(" Qwerty "), "Qwerty ")
    }

    func testMatch() throws {
        XCTAssertTrue(stdlib.match("qwe 564", "\\w+\\s{1}\\d{2,5}"))
        XCTAssertTrue(stdlib.match("qweergeqr 15", "\\w+\\s{1}\\d{2,5}"))
        XCTAssertTrue(stdlib.match("qhrwtherhearhwe 564312", "\\w+\\s{1}\\d{2,5}"))
        XCTAssertTrue(stdlib.match("qwe\t564", "\\w+\\s{1}\\d{2,5}"))
        XCTAssertTrue(stdlib.match("qwe 32145111111123412341", "\\w+\\s{1}\\d{2,}"))

        XCTAssertFalse(stdlib.match("qwe  564", "\\w+\\s{1}\\d{2,5}"))
        XCTAssertFalse(stdlib.match(" 564", "\\w+\\s{1}\\d{2,5}"))
        XCTAssertFalse(stdlib.match("qwe 4", "\\w+\\s{1}\\d{2,5}"))
    }

    func testUnicode() throws {
        XCTAssertEqual(stdlib.unicode("abc", 0), 97)
        XCTAssertEqual(stdlib.unicode("abc", 1), 98)
        XCTAssertEqual(stdlib.unicode("abc", 2), 99)
    }

    func testChar() throws {
        XCTAssertEqual(stdlib.char(-1), "")
        XCTAssertEqual(stdlib.char(97), "a")
        XCTAssertEqual(stdlib.char(98), "b")
        XCTAssertEqual(stdlib.char(99), "c")
    }

    func testAbs() throws {
        XCTAssertEqual(stdlib.abs(5.4321), 5.4321)
        XCTAssertEqual(stdlib.abs(-5.4321), 5.4321)
    }

    func testSqrt() throws {
        XCTAssertEqual(stdlib.sqrt(10000), 100)
        XCTAssertTrue(stdlib.sqrt(-2).isNaN)
    }

    func testCeil() throws {
        XCTAssertEqual(stdlib.ceil(123.456), 124)
    }

    func testFloor() throws {
        XCTAssertEqual(stdlib.floor(123.456), 123)
    }

    func testRoundInl() throws {
        var v = stdlib.roundInl(1.1, 1)
        XCTAssertEqual(v, 1.1, "Expected '1.1' but was found: \(v)")

        v = stdlib.roundInl(0.12, 1);
        XCTAssertEqual(v, 0.1, "Expected '0.1' but was found: \(v)")

        v = stdlib.roundInl(0.752, 3);
        XCTAssertEqual(v, 0.752, "Expected '0.752' but was found: \(v)")

        v = stdlib.roundInl(-0.12, 1);
        XCTAssertEqual(v,-0.1, "Expected '-0.1' but was found: \(v)")

        v = stdlib.roundInl(-1.752, 0);
        XCTAssertEqual(v,-2, "Expected '-2' but was found: \(v)")
    }

    func testLogarithm() throws {
        XCTAssertEqual(stdlib.log10(100), 2)
        XCTAssertEqual(stdlib.log(64) / stdlib.log(8), 2)
    }

    func testMkdate() throws {
        let year = 2048
        let month = 8
        let day = 16
        let hour = 16
        let minute = 32
        let second = 32
        let millisecond = 512

        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(abbreviation: "UTC")!

        if let date = stdlib.mkdate(year, month, day) {
            XCTAssertEqual(calendar.component(.year, from: date), year)
            XCTAssertEqual(calendar.component(.month, from: date), month)
            XCTAssertEqual(calendar.component(.day, from: date), day)
        } else {
            XCTFail("Can't create date")
        }

        if let datetime = stdlib.mkdatetime(year, month, day, hour, minute, second, millisecond) {
            XCTAssertEqual(calendar.component(.year, from: datetime), year)
            XCTAssertEqual(calendar.component(.month, from: datetime), month)
            XCTAssertEqual(calendar.component(.day, from: datetime), day)
            XCTAssertEqual(calendar.component(.hour, from: datetime), hour)
            XCTAssertEqual(calendar.component(.minute, from: datetime), minute)
            XCTAssertEqual(calendar.component(.second, from: datetime), second)
            let extractedNanoseconds = calendar.component(.nanosecond, from: datetime)
            let roundedNanoseconds = stdlib.round(Double(extractedNanoseconds), 6)
            XCTAssertEqual(roundedNanoseconds, Double(millisecond * 1000000))
        } else {
            XCTFail("Can't create datetime")
        }
    }

    func testDateComponents() throws {
        var year = 2048
        var month = 8
        var day = 16
        var hour = 16
        var minute = 32
        var second = 32
        var millisecond = 512

        var datetime = stdlib.mkdatetime(year, month, day, hour, minute, second, millisecond)
        XCTAssertEqual(stdlib.year(datetime), year)
        XCTAssertEqual(stdlib.month(datetime), month)
        XCTAssertEqual(stdlib.day(datetime), day)
        XCTAssertEqual(stdlib.hour(datetime), hour)
        XCTAssertEqual(stdlib.minute(datetime), minute)
        XCTAssertEqual(stdlib.second(datetime), second)
        XCTAssertEqual(stdlib.dayOfWeek(datetime), 1)
        var roundedSeconds = stdlib.round(stdlib.seconds(datetime), -3)
        XCTAssertEqual(roundedSeconds, Double(second) + Double(millisecond) / 1000)
        XCTAssertEqual(stdlib.millisecond(datetime), millisecond)

        year = 2022
        month = 6
        day = 15
        hour = 12
        minute = 48
        second = 15
        millisecond = 648

        datetime = stdlib.mkdatetime(year, month, day, hour, minute, second, millisecond)
        XCTAssertEqual(stdlib.year(datetime), year)
        XCTAssertEqual(stdlib.month(datetime), month)
        XCTAssertEqual(stdlib.day(datetime), day)
        XCTAssertEqual(stdlib.hour(datetime), hour)
        XCTAssertEqual(stdlib.minute(datetime), minute)
        XCTAssertEqual(stdlib.second(datetime), second)
        XCTAssertEqual(stdlib.dayOfWeek(datetime), 4)
        roundedSeconds = stdlib.round(stdlib.seconds(datetime), -3)
        XCTAssertEqual(roundedSeconds, Double(second) + Double(millisecond) / 1000)
        XCTAssertEqual(stdlib.millisecond(datetime), millisecond)
    }

    func testLeapYear() throws {
        let month = 8
        let day = 16

        let years: [Int: Bool] = [
            1000: false,
            1600: true,
            2000: true,
            2020: true,
            2030: false,
        ]

        for (year, isLeap) in years {
            let date = stdlib.mkdate(year, month, day)
            XCTAssertEqual(try stdlib.leapYear(date), isLeap, "Leap for \(year) determining failed")
        }

    }

    func testLocal() throws {
        let nowLocal = stdlib.round(stdlib.nowlocal()?.timeIntervalSince1970 ?? .nan, 0)
        let nowUtc = stdlib.round(stdlib.nowutc()?.timeIntervalSince1970 ?? .nan, 0)
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        let offset = calendar.timeZone.secondsFromGMT()
        XCTAssertEqual(Int(nowUtc - nowLocal), offset)
    }

    func testJdnConverter() throws {
        typealias DateStruct = (
            year: Int,
            month: Int,
            day: Int,
            hour: Int,
            minute: Int,
            second: Int,
            millisecond: Int
        )

        let dates: [String: DateStruct] = [
            "02/15/2000 18:00:00.0000": DateStruct(
                year: 2000,
                month: 2,
                day: 15,
                hour: 18,
                minute: 0,
                second: 0,
                millisecond: 0
            ),
            "01/31/2020 13:07:35.2450": DateStruct(
                year: 2020,
                month: 1,
                day: 31,
                hour: 13,
                minute: 7,
                second: 35,
                millisecond: 245
            ),
            "09/01/2021 00:07:35.2450": DateStruct(
                year: 2021,
                month: 9,
                day: 1,
                hour: 0,
                minute: 7,
                second: 35,
                millisecond: 245
            ),
        ]

        for (date, values) in dates {
            var d = stdlib.mkdatetime(
                values.year,
                values.month,
                values.day,
                values.hour,
                values.minute,
                values.second,
                values.millisecond
            )
            let r = stdlib.toJdn(d)
            d = stdlib.fromJdn(r)

            XCTAssertEqual(stdlib.millisecond(d), values.millisecond, "Millisecond in date \(date) is \(stdlib.millisecond(d)) instead \(values.millisecond)")
            XCTAssertEqual(stdlib.second(d), values.second, "Second in date \(date) is \(stdlib.second(d)) instead \(values.second)")
            XCTAssertEqual(stdlib.minute(d), values.minute, "Minute in date \(date) is \(stdlib.minute(d)) instead \(values.minute)")
            XCTAssertEqual(stdlib.hour(d), values.hour, "Hour in date \(date) is \(stdlib.hour(d)) instead \(values.hour)")
            XCTAssertEqual(stdlib.day(d), values.day, "Day in date \(date) is \(stdlib.day(d)) instead \(values.day)")
            XCTAssertEqual(stdlib.month(d), values.month, "Month in date \(date) is \(stdlib.month(d)) instead \(values.month)")
            XCTAssertEqual(stdlib.year(d), values.year, "Year in date \(date) is \(stdlib.year(d)) instead \(values.year)")
        }
    }
    
    func testFromJdn() throws {
        var d0 = stdlib.mkdatetime(1980, 1, 1, 0, 7, 35, 245)
        let end = stdlib.mkdatetime(2030, 1, 1, 0, 7, 35, 245)
        
        XCTAssertNotNil(d0)
        XCTAssertNotNil(end)
        
        while(d0! < end!) {
            let r = stdlib.toJdn(d0)
            let d1 = stdlib.fromJdn(r)
            
            let d1Millisecond = stdlib.millisecond(d1)
            let d1Scond = stdlib.second(d1)
            let d1Minute = stdlib.minute(d1)
            let d1Hour = stdlib.hour(d1)
            let d1Day = stdlib.day(d1)
            let d1Month = stdlib.month(d1)
            let d1Year = stdlib.year(d1)
            
            let d0Millisecond = stdlib.millisecond(d0)
            let d0Scond = stdlib.second(d0)
            let d0Minute = stdlib.minute(d0)
            let d0Hour = stdlib.hour(d0)
            let d0Day = stdlib.day(d0)
            let d0Month = stdlib.month(d0)
            let d0Year = stdlib.year(d0)
            
            XCTAssertEqual(d1Millisecond, d0Millisecond, "ms should be \(d0Millisecond) but found \(d1Millisecond) for date: \(d0) / \(d1)")
            XCTAssertEqual(d1Scond, d0Scond, "second should be \(d0Scond) but found \(d1Scond) for date: \(d0) / \(d1)")
            XCTAssertEqual(d1Minute, d0Minute, "minute should be \(d0Minute) but found \(d1Minute) for date: \(d0) / \(d1)")
            XCTAssertEqual(d1Hour, d0Hour, "hour should be \(d0Hour) but found \(d1Hour) for date: \(d0) / \(d1)")
            XCTAssertEqual(d1Day, d0Day, "day should be \(d0Day) but found \(d1Day) for date: \(d0) / \(d1)")
            XCTAssertEqual(d1Month, d0Month, "month should be \(d0Month) but found \(d1Month) for date: \(d0) / \(d1)")
            XCTAssertEqual(d1Year, d0Year, "year should be \(d0Year) but found \(d1Year) for date: \(d0) / \(d1)")
            
            d0!.addTimeInterval(259200) // 3 days
        }
    }

    func testPrint() throws {
        stdlib.print("debug message")
    }

}

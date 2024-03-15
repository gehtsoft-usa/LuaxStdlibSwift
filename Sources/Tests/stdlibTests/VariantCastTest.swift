//
//  VariantCastTest.swift
//  
//
//  Created by Nikolai Borovennikov on 13.06.2022.
//

import XCTest
import LuaxStdlib



class VariantCastTest: XCTestCase {

    func testFromInt() throws {
        let int = 1024
        let intVariant = VariantCast.fromInt(int)
        XCTAssertEqual(int, try? intVariant?.asInt())
        XCTAssert(intVariant?.isInt() == true)
    }

    func testFromReal() throws {
        let real = 3.14
        let realVariant = VariantCast.fromReal(real)
        XCTAssertEqual(real, try? realVariant?.asReal())
        XCTAssert(realVariant?.isReal() == true)
    }

    func testFromDatetime() throws {
        let now = Date()
        let datetimeVariant = VariantCast.fromDatetime(now)
        XCTAssertEqual(now, datetimeVariant?.asDatetime())
        XCTAssert(datetimeVariant?.isDatetime() == true)
    }

    func testFromBoolean() throws {
        let boolean = true
        let booleanVariant = VariantCast.fromBoolean(boolean)
        XCTAssertEqual(boolean, try? booleanVariant?.asBoolean())
        XCTAssert(booleanVariant?.isBoolean() == true)
    }

    func testFromString() throws {
        let string = "string"
        let stringVariant = VariantCast.fromString(string)
        XCTAssertEqual(string, stringVariant?.asString())
        XCTAssert(stringVariant?.isString() == true)
    }

    func testFromObject() throws {
        let object = Data("some string".utf8)
        guard let objectVariant = VariantCast.fromObject(object as NSObject) else {
            XCTFail("Can't create variant from object")
            return
        }
        guard let restoredObject = objectVariant.asObject() as? Data else {
            XCTFail("Can't restore object from variant")
            return
        }
        XCTAssertEqual(String(data: object, encoding: .utf8),
                       String(data: restoredObject, encoding: .utf8))
        XCTAssertTrue(objectVariant.isObject())
    }

    func testCastToInt() throws {
        let int = 1024
        let intVariant = Variant(int)
        let restoredInt = VariantCast.castToInt(intVariant)
        XCTAssertEqual(int, restoredInt)

        let stringVariant = Variant("string")
        let restoredInt2 = VariantCast.castToInt(stringVariant)
        XCTAssertNotEqual(int, restoredInt2)
    }

    func testCastToReal() throws {
        let real = 3.14
        let realVariant = Variant(real)
        let restoredReal = VariantCast.castToReal(realVariant)
        XCTAssertEqual(real, restoredReal)

        let stringVariant = Variant("string")
        let restoredReal2 = VariantCast.castToReal(stringVariant)
        XCTAssertNotEqual(real, restoredReal2)
    }

    func testCastToDatetime() throws {
        let now = Date()
        let datetimeVariant = Variant(now)
        let restoredDatetime = VariantCast.castToDatetime(datetimeVariant)
        XCTAssertEqual(now, restoredDatetime)

        let stringVariant = Variant("string")
        let restoredDatetime2 = VariantCast.castToDatetime(stringVariant)
        XCTAssertNotEqual(now, restoredDatetime2)
    }

    func testCastToBoolean() throws {
        let boolean = true
        let booleanVariant = Variant(boolean)
        let restoredBoolean = VariantCast.castToBoolean(booleanVariant)
        XCTAssertEqual(boolean, restoredBoolean)

        let stringVariant = Variant("string")
        let restoredBoolean2 = VariantCast.castToBoolean(stringVariant)
        XCTAssertNotEqual(boolean, restoredBoolean2)
    }

    func testCastToString() throws {
        let string = "string"
        let stringVariant = Variant(string)
        let restoredString = VariantCast.castToString(stringVariant)
        XCTAssertEqual(string, restoredString)
    }

    func testCastToObject() throws {
        let object = Data("some string".utf8)
        let objectVariant = Variant(object)
        guard let restoredObject = VariantCast.castToObject(objectVariant) as? Data else {
            XCTFail("Can't restore object from variant")
            return
        }
        XCTAssertEqual(String(data: object, encoding: .utf8),
                       String(data: restoredObject, encoding: .utf8))
    }
    
}

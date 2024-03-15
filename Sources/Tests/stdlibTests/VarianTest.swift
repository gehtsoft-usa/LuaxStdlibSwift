//
//  VarianTest.swift
//  
//
//  Created by Nikolai Borovennikov on 10.06.2022.
//

import XCTest
import LuaxStdlib



class VarianTest: XCTestCase {

    func testEqualsNil() throws {
        let variantNil1 = Variant(nil)
        let variantNil2 = Variant(nil)
        XCTAssertTrue(variantNil1.equals(variantNil2))

        let variantValue = Variant(1024)
        XCTAssertFalse(variantValue.equals(variantNil1))
        XCTAssertFalse(variantNil1.equals(variantValue))
    }

    func testEqualsInt() throws {
        let int = 1024
        let intVariant = Variant(int)
        XCTAssertTrue(intVariant.equals(int))
        XCTAssertTrue(intVariant.equals(intVariant))

        let doubleVariant = Variant(Double(int))
        XCTAssertTrue(intVariant.equals(doubleVariant))

        XCTAssertFalse(intVariant.equals(0))
        XCTAssertFalse(intVariant.equals(Variant("string")))
    }

    func testEqualsReal() throws {
        let real = 3.14
        let realVariant = Variant(real)
        XCTAssertTrue(realVariant.equals(real))
        XCTAssertTrue(realVariant.equals(realVariant))

        let int = 1024
        let realInt = Double(int)
        let realIntVariant = Variant(realInt)
        let doubleVariant = Variant(int)
        XCTAssertTrue(realIntVariant.equals(doubleVariant))

        XCTAssertFalse(realVariant.equals(0))
        XCTAssertFalse(realVariant.equals(Variant("string")))
    }

    func testTypes() throws {
        let intVariant = Variant(1024)
        XCTAssertEqual(intVariant.type(), "Integer")

        let doubleVariant = Variant(3.14)
        XCTAssertEqual(doubleVariant.type(), "Double")

        let dateVariant = Variant(Date())
        XCTAssertEqual(dateVariant.type(), "Date")

        let stringVariant = Variant("String")
        XCTAssertEqual(stringVariant.type(), "String")

        let boolVariant = Variant(true)
        XCTAssertEqual(boolVariant.type(), "Boolean")

        let objectVariant = Variant(Data("some string".utf8))
        XCTAssertEqual(objectVariant.type(), "Object")
    }

    func testAsInt() throws {
        let int = 1024
        let intVariant = Variant(int)
        XCTAssertEqual(try? intVariant.asInt(), int)

        let doubleVariant = Variant(Double(int))
        XCTAssertEqual(try? doubleVariant.asInt(), int)

        let stringIntVariant = Variant("\(int)")
        XCTAssertEqual(try? stringIntVariant.asInt(), int)

        let string = "string"
        let stringVariant = Variant(string)
        do {
            let _ = try stringVariant.asInt()
            XCTFail("Bool variant to int must fail")
        } catch {
            switch (error as? VariantError) {
            case .wrongVariantType(let data):
                XCTAssertEqual(string, data as? String)
            case .unsupportedType:
                XCTFail("To int must fail with wrongVarianType, not unsupportedType")
            case .none:
                XCTFail("To int must fail with VariantError.wrongVarianType")
            }
            XCTAssertTrue(error is VariantError)
        }
    }

    func testAsReal() throws {
        let real = Double(3.14)
        let realVariant = Variant(real)
        XCTAssertEqual(try? realVariant.asReal(), real)

        let stringVariant = Variant("string")
        do {
            let _ = try stringVariant.asReal()
            XCTFail("String variant to real must fail")
        } catch {
            switch (error as? VariantError) {
            case .wrongVariantType(let data):
                XCTAssertEqual("string", data as? String)
            case .unsupportedType:
                XCTFail("To real must fail with wrongVarianType, not unsupportedType")
            case .none:
                XCTFail("To real must fail with VariantError.wrongVarianType")
            }
        }
    }

    func testAsDatetime() throws {
        let now = Date()
        let dateVariant = Variant(now)
        XCTAssertEqual(dateVariant.asDatetime(), now)
    }

    func testAsBoolean() throws {
        let bool = true
        let boolVariant = Variant(bool)
        XCTAssertEqual(try? boolVariant.asBoolean(), bool)

        let stringTrue = "true"
        let stringTrueVariant = Variant(stringTrue)
        XCTAssertEqual(try? stringTrueVariant.asBoolean(), true)

        let stringFalse = "false"
        let stringFalseVariant = Variant(stringFalse)
        XCTAssertEqual(try? stringFalseVariant.asBoolean(), false)

        let now = Date()
        let dateVariant = Variant(now)
        do {
            let _ = try dateVariant.asBoolean()
            XCTFail("Date variant to boolean must fail")
        } catch {
            switch (error as? VariantError) {
            case .wrongVariantType(let data):
                XCTAssertEqual(now, data as? Date)
            case .unsupportedType:
                XCTFail("To boolean must fail with wrongVarianType, not unsupportedType")
            case .none:
                XCTFail("To boolean must fail with VariantError.wrongVarianType")
            }
        }
    }

    func testAsString() throws {
        let string = "string"
        let stringVariant = Variant(string)
        XCTAssertEqual(stringVariant.asString(), string)

        let int = 1024
        let intVariant = Variant(int)
        XCTAssertEqual(intVariant.asString(), "\(int)")

        let double = Double(3.14)
        let realVariant = Variant(double)
        XCTAssertEqual(realVariant.asString(), "\(double)")

        let now = Date()
        let dateVariant = Variant(now)
        XCTAssertEqual(dateVariant.asString(), DateFormatter().string(from: now))

        let data = Data("string".utf8)
        let objectVariant = Variant(data)
        XCTAssertEqual(objectVariant.asString(), "\(data)")

        let emptyVariant = Variant(nil)
        XCTAssertNil(emptyVariant.asString())
    }

    func testAsObject() throws {
        let string = "string"
        let data = Data(string.utf8)
        let dataVariant = Variant(data)
        guard let extractedData = dataVariant.asObject() as? Data else {
            XCTFail("Get data from asObject failed")
            return
        }
        XCTAssertEqual(String(data: extractedData, encoding: .utf8), string)
    }

    func testIsInt() throws {
        let int = 1024
        let intVariant = Variant(int)
        XCTAssertTrue(intVariant.isInt())
        XCTAssertFalse(intVariant.isReal())
        XCTAssertFalse(intVariant.isString())
        XCTAssertFalse(intVariant.isDatetime())
        XCTAssertFalse(intVariant.isBoolean())
    }

    func testIsReal() throws {
        let real = 3.14
        let realVariant = Variant(real)
        XCTAssertTrue(realVariant.isReal())
        XCTAssertFalse(realVariant.isInt())
        XCTAssertFalse(realVariant.isString())
        XCTAssertFalse(realVariant.isDatetime())
        XCTAssertFalse(realVariant.isBoolean())
    }

    func testIsDatetime() throws {
        let now = Date()
        let dateVariant = Variant(now)
        XCTAssertTrue(dateVariant.isDatetime())
        XCTAssertFalse(dateVariant.isReal())
        XCTAssertFalse(dateVariant.isInt())
        XCTAssertFalse(dateVariant.isString())
        XCTAssertFalse(dateVariant.isBoolean())
    }

    func testIsBoolean() throws {
        let bool = true
        let boolVariant = Variant(bool)
        XCTAssertTrue(boolVariant.isBoolean())
        XCTAssertFalse(boolVariant.isString())
        XCTAssertFalse(boolVariant.isDatetime())
        XCTAssertFalse(boolVariant.isReal())
        XCTAssertFalse(boolVariant.isInt())
    }

    func testIsString() throws {
        let string = "string"
        let stringVariant = Variant(string)
        XCTAssertTrue(stringVariant.isString())
        XCTAssertFalse(stringVariant.isBoolean())
        XCTAssertFalse(stringVariant.isDatetime())
        XCTAssertFalse(stringVariant.isReal())
        XCTAssertFalse(stringVariant.isInt())
    }

    func testIsObject() throws {
        let string = "string"
        let data = Data(string.utf8)
        let dataVariant = Variant(data)
        XCTAssertTrue(dataVariant.isObject())
        XCTAssertFalse(dataVariant.isString())
        XCTAssertFalse(dataVariant.isBoolean())
        XCTAssertFalse(dataVariant.isDatetime())
        XCTAssertFalse(dataVariant.isReal())
        XCTAssertFalse(dataVariant.isInt())
    }

}

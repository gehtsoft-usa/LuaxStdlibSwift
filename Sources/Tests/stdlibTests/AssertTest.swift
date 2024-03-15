//
//  AssertTest.swift
//  
//
//  Created by Nikolai Borovennikov on 30.06.2022.
//

import XCTest
import LuaxStdlib

class AssertTest: XCTestCase {

    func testIsTrue() throws {
        do {
            try _assert_.isTrue(true, "")
        } catch {
            print(error)
            XCTFail()
        }
    }

    func testIsFalse() throws {
        do {
            try _assert_.isFalse(false, "")
        } catch {
            print(error)
            XCTFail()
        }
    }

    func testApproximatelyEquals() throws {
        do {
            try _assert_.approximatelyEquals(1, 1.0000001, 0.000001, "")
        } catch {
            print(error)
            XCTFail()
        }
    }

    func testEquals() throws {
        do {
            try _assert_.equals(0, 0, "true")
        } catch {
            print(error)
            XCTFail()
        }

        do {
            try _assert_.equals(1, 1, "true")
        } catch {
            print(error)
            XCTFail()
        }

        do {
            try _assert_.equals(2.1, 2.1, "true")
        } catch {
            print(error)
            XCTFail()
        }

        let now = Date()
        do {
            try _assert_.equals(now, now, "true")
        } catch {
            print(error)
            XCTFail()
        }

        do {
            try _assert_.equals("abc", "abc", "true")
        } catch {
            print(error)
            XCTFail()
        }

        do {
            try _assert_.equals(0, 10, "Error")
            XCTFail()
        } catch {
            print(error)
        }

        do {
            try _assert_.equals(variantCast.fromInt(0), variantCast.fromInt(1), "Error")
            XCTFail()
        } catch {
            print(error)
        }

        do {
            try _assert_.equals(0, "10", "Error")
            XCTFail()
        } catch {
            print(error)
        }
    }

    func testThrows() throws {
        let invoker = Invoker(mustThrow: true)
        try Assert._throws_(invoker, nil)
    }

    func testDoesNotThrow() throws {
        let invoker = Invoker(mustThrow: false)
        try Assert.doesNotThrow(invoker, nil)
    }

//    @Test
//    public void checkObjects(){
//        Assert.assertEquals(assertStdlib._checkObjects(new Date(2022),new Date(2022)), true);
//        Assert.assertEquals(assertStdlib._checkObjects(1.3,1.3), true);
//        Assert.assertEquals(assertStdlib._checkObjects(0,0), true);
//        Assert.assertEquals(assertStdlib._checkObjects(1,1), true);
//        Assert.assertEquals(assertStdlib._checkObjects(1,2), false);
//    }

    func testDoesNotEqual() throws {
        do {
            try _assert_.doesNotEqual(0, 2, "No equals")
        } catch {
            print(error)
            XCTFail()
        }

        do {
            try _assert_.doesNotEqual(1, 2, "No equals")
        } catch {
            print(error)
            XCTFail()
        }

        do {
            try _assert_.doesNotEqual(1.1, 2.1, "No equals")
        } catch {
            print(error)
            XCTFail()
        }

        let now = Date().timeIntervalSince1970
        let future = now + 3600
        do {
            try _assert_.doesNotEqual(Date(timeIntervalSince1970: now), Date(timeIntervalSince1970: future), "No equals")
        } catch {
            print(error)
            XCTFail()
        }

        do {
            try _assert_.doesNotEqual("Abc", "abd", "No equals")
        } catch {
            print(error)
            XCTFail()
        }

        do {
            try _assert_.doesNotEqual("equal", "equal", "Error")
            XCTFail()
        } catch {
            print(error)
        }
    }

    func testGreater() throws {
        do {
            try _assert_.greater(10.5, 0.0, "true")
        } catch {
            print(error)
            XCTFail()
        }

        do {
            try _assert_.greater(2, 1, "true")
        } catch {
            print(error)
            XCTFail()
        }

        do {
            try _assert_.greater(2.4, 1.6, "true")
        } catch {
            print(error)
            XCTFail()
        }

        do {
            try _assert_.greater(Date(timeIntervalSince1970: 2023), Date(timeIntervalSince1970: 2022), "true")
        } catch {
            print(error)
            XCTFail()
        }

        do {
            try _assert_.greater("Abc", "Ab", "true")
        } catch {
            print(error)
            XCTFail()
        }

        do {
            try _assert_.greater(21.3, 75.4, "Error")
            XCTFail()
        } catch {
            print(error)
        }
    }

    func testGreaterOrEqual() throws {
        do {
            try _assert_.greaterOrEqual(0, 0, "true")
        } catch {
            print(error)
            XCTFail()
        }

        do {
            try _assert_.greaterOrEqual(15, 0, "true")
        } catch {
            print(error)
            XCTFail()
        }

        do {
            try _assert_.greaterOrEqual(2, 1, "true")
        } catch {
            print(error)
            XCTFail()
        }

        do {
            try _assert_.greaterOrEqual(2, 2, "true")
        } catch {
            print(error)
            XCTFail()
        }

        do {
            try _assert_.greaterOrEqual(Date(timeIntervalSince1970: 2022), Date(timeIntervalSince1970: 2021), "true")
        } catch {
            print(error)
            XCTFail()
        }

        do {
            try _assert_.greaterOrEqual("Abc", "Ab", "true")
        } catch {
            print(error)
            XCTFail()
        }

        do {
            try _assert_.greaterOrEqual("Abc", "Abc", "true")
        } catch {
            print(error)
            XCTFail()
        }

        do {
            try _assert_.greaterOrEqual(1, 78, "Error")
            XCTFail()
        } catch {
            print(error)
        }
    }

    func testLess() throws {
        do {
            try _assert_.less(1, 2, "less")
        } catch {
            print(error)
            XCTFail()
        }

        do {
            try _assert_.less(0, 20, "less")
        } catch {
            print(error)
            XCTFail()
        }

        do {
            try _assert_.less(Date(timeIntervalSince1970: 2022), Date(timeIntervalSince1970: 2023), "true")
        } catch {
            print(error)
            XCTFail()
        }

        do {
            try _assert_.less("Abc", "Abcde", "true")
        } catch {
            print(error)
            XCTFail()
        }

        do {
            try _assert_.less(45.5, 0.0, "Error")
            XCTFail()
        } catch {
            print(error)
        }
    }

    func testLessOrEqual() throws {
        do {
            try _assert_.lessOrEqual(0, 0, "less")
        } catch {
            print(error)
            XCTFail()
        }

        do {
            try _assert_.lessOrEqual(0, 7, "less")
        } catch {
            print(error)
            XCTFail()
        }

        do {
            try _assert_.lessOrEqual(1, 2, "less")
        } catch {
            print(error)
            XCTFail()
        }

        do {
            try _assert_.lessOrEqual(2, 2, "Equal")
        } catch {
            print(error)
            XCTFail()
        }

        do {
            try _assert_.lessOrEqual(Date(timeIntervalSince1970: 2022), Date(timeIntervalSince1970: 2023), "less")
        } catch {
            print(error)
            XCTFail()
        }

        do {
            try _assert_.lessOrEqual(Date(timeIntervalSince1970: 2021), Date(timeIntervalSince1970: 2024), "equal")
        } catch {
            print(error)
            XCTFail()
        }

        do {
            try _assert_.lessOrEqual("Abc", "Abcde", "less")
        } catch {
            print(error)
            XCTFail()
        }

        do {
            try _assert_.lessOrEqual("Abcde", "Abcde", "equal")
        } catch {
            print(error)
            XCTFail()
        }

        do {
            try _assert_.lessOrEqual(21, 0, "Error")
            XCTFail()
        } catch {
            print(error)
        }
    }

    func testMatches() throws {
        do {
            try _assert_.matches("abc", "/Abc/i", "Match")
        } catch {
            print(error)
            XCTFail()
        }

        do {
            try _assert_.matches("00000456265", "/00000456265/", "Match")
        } catch {
            print(error)
            XCTFail()
        }

        do {
            try _assert_.matches("123", "/846/um", "Error")
            XCTFail()
        } catch {
            print(error)
        }
    }

    func testDoesNotMatch() throws {
        do {
            try _assert_.doesNotMatch("abc", "/zcx/i", "Not match")
        } catch {
            print(error)
            XCTFail()
        }
        do {
            try _assert_.doesNotMatch("123", "/846/um", "Not match")
        } catch {
            print(error)
            XCTFail()
        }
        do {
            try _assert_.doesNotMatch("00000456265", "/00000456265/", "Error")
            XCTFail()
        } catch {
            print(error)
        }
    }

    func testEqualsXML(){
        let first = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><fxmsg v=\"pdas\"><m t=\"U54\" s=\"6\" q=\"0\"><f n=\"112\">trading-session-1</f><f n=\"336\">FXCM</f><f n=\"35\">U54</f><f n=\"625\">U1R2</f><f n=\"9028\">37</f><f n=\"SID\">trading-session</f></m></fxmsg>"
        let second = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><fxmsg v=\"pdas\"><m t=\"U54\" s=\"6\" q=\"0\"><f n=\"336\">FXCM</f><f n=\"112\">trading-session-1</f><f n=\"SID\">trading-session</f><f n=\"35\">U54</f><f n=\"625\">U1R2</f><f n=\"9028\">37</f></m></fxmsg>"

        do {
            try _assert_.equalsXML(first, second, "")
        } catch {
            print(error)
            XCTFail()
        }

        do {
            try _assert_.equalsXML(Variant(first), Variant(second), "")
        } catch {
            print(error)
            XCTFail()
        }

        let third = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><fxmsg v=\"pdas\"><m t=\"U54\" s=\"6\" q=\"0\"><f n=\"336\">FXCM</f><f n=\"112\">trading-session-1</f><f n=\"SID\">trading-session</f><f n=\"40\">U54</f><f n=\"625\">U1R2</f><f n=\"9028\">37</f></m></fxmsg>"
        do {
            try _assert_.equalsXML(Variant(first), Variant(third), "")
            XCTFail()
        } catch {
            print(error)
        }
    }

}

class Invoker: action {

    fileprivate enum InvokerError: Error {
        case justThrow
    }
    
    let mustThrow: Bool

    init(mustThrow: Bool) {
        self.mustThrow = mustThrow
    }

    func invoke() throws {
        if mustThrow {
            throw InvokerError.justThrow
        }
    }
}


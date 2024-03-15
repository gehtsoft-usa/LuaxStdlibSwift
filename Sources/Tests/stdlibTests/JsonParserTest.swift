import XCTest
import LuaxStdlib

fileprivate let jsonSource1 = "[{\"minimumVersion\": \"1.0\",\"clientId\": \"37i1qd0ifrwjqje71u46z3k4gdy5b\",\"supportedConnectionTypes\": [\"websocket\", null],\"advice\": {\"interval\": 1.2,\"timeout\": 30000,\"reconnect\": \"retry\"},\"channel\": \"/meta/handshake\",\"version\": \"1.0\",\"successful\": true}]"
fileprivate let jsonSource2 = "{\"minimumVersion\": \"1.0\",\"clientId\": \"37i1qd0ifrwjqje71u46z3k4gdy5b\",\"supportedConnectionTypes\": [\"websocket\", null],\"advice\": {\"interval\": 1.2,\"timeout\": 30000,\"reconnect\": \"retry\"},\"channel\": \"/meta/handshake\",\"version\": \"1.0\",\"successful\": true}"
fileprivate let jsonSource3 = "{\"datetime\": 1665119461000}";
fileprivate let jsonSource4 = "{\"bigint\": 7151800870659686411}";

class JsonParserTest: XCTestCase {

    let parser = jsonParser()

    func testTypes() throws {
        guard let root = try parser.parse(jsonSource1) else {
            XCTFail()
            return
        }
        XCTAssertEqual(root.getType(), jsonNode.ARRAY)
        XCTAssertEqual(try root.getChildrenCount(), 1)
        guard let node = try root.getChildByIndex(0) else {
            XCTFail()
            return
        }
        XCTAssertEqual(node.getType(), jsonNode.OBJECT)
        XCTAssertEqual(try node.getChildrenCount(), 7)
        guard let child = try node.getPropertyByName("successful") else {
            XCTFail()
            return
        }
        XCTAssertEqual(child.getType(), jsonNode.BOOLEAN)
        guard let child = try node.getChildByIndex(6) else {
            XCTFail()
            return
        }
        XCTAssertEqual(child.getType(), jsonNode.PROPERTY)
        XCTAssertEqual(try child.getName(), "successful")
        guard let child = try child.getValueAsNode() else {
            XCTFail()
            return
        }
        XCTAssertEqual(child.getType(), jsonNode.BOOLEAN)
        
        guard let child = try node.getPropertyByName("supportedConnectionTypes") else {
            XCTFail()
            return
        }
        XCTAssertEqual(child.getType(), jsonNode.ARRAY)
        XCTAssertEqual(try child.getChildrenCount(), 2)
        guard let child0 = try child.getChildByIndex(0),
              let child1 = try child.getChildByIndex(1)
        else {
            XCTFail("Item has NIL at required indice")
            return
        }
        XCTAssertEqual(child0.getType(), jsonNode.STRING)
        XCTAssertEqual(child1.getType(), jsonNode.NIL)
        
        guard let child = try node.getPropertyByName("advice") else {
            XCTFail()
            return
        }
        XCTAssertEqual(child.getType(), jsonNode.OBJECT)
        XCTAssertEqual(try child.getChildrenCount(), 3)
        guard let child0 = try child.getPropertyByName("reconnect")
        else {
            XCTFail("Item has NIL at required indice")
            return
        }
        XCTAssertEqual(child0.getType(), jsonNode.STRING)
        guard let child0 = try child.getPropertyByName("timeout")
        else {
            XCTFail("Item has NIL at required indice")
            return
        }
        XCTAssertEqual(child0.getType(), jsonNode.INT)
        guard let child0 = try child.getPropertyByName("interval")
        else {
            XCTFail("Item has NIL at required indice")
            return
        }
        XCTAssertEqual(child0.getType(), jsonNode.REAL)
        guard let child0 = try child.getPropertyByName("nil")
        else {
            XCTFail("Item has NIL at required indice")
            return
        }
        XCTAssertEqual(child0.getType(), jsonNode.NIL)
    }

    func testValues() throws {
        guard let root = try parser.parse(jsonSource1) else {
            XCTFail()
            return
        }
        guard let node = try root.getChildByIndex(0) else {
            XCTFail()
            return
        }
        guard let child = try node.getPropertyByName("successful") else {
            XCTFail()
            return
        }
        XCTAssertEqual(try child.getValueAsBoolean(), true)
        guard let child = try node.getChildByIndex(6) else {
            XCTFail()
            return
        }
        guard let child = try child.getValueAsNode() else {
            XCTFail()
            return
        }
        XCTAssertEqual(try child.getValueAsBoolean(), true)
        
        guard let child = try node.getPropertyByName("supportedConnectionTypes") else {
            XCTFail()
            return
        }
        XCTAssertEqual(try child.getChildByIndex(0)!.getValueAsString(), "websocket")
        
        guard let child = try node.getPropertyByName("advice") else {
            XCTFail()
            return
        }
        guard let child0 = try child.getPropertyByName("reconnect")
        else {
            XCTFail("Item has NIL at required indice")
            return
        }
        XCTAssertEqual(try child0.getValueAsString(), "retry")
        guard let child0 = try child.getPropertyByName("timeout")
        else {
            XCTFail("Item has NIL at required indice")
            return
        }
        XCTAssertEqual(try child0.getValueAsInt(), 30000)
        guard let child0 = try child.getPropertyByName("interval")
        else {
            XCTFail("Item has NIL at required indice")
            return
        }
        XCTAssertEqual(try child0.getValueAsReal(), 1.2)
    }
    
    func testObjectType() throws {
        guard let root = try parser.parse(jsonSource2) else {
            XCTFail()
            return
        }
        XCTAssertEqual(root.getType(), jsonNode.OBJECT)
    }
    
    func testGetValueAsDatetime() throws {
        guard let root = try parser.parse(jsonSource3) else {
            XCTFail()
            return
        }
        XCTAssertEqual(root.getType(), jsonNode.OBJECT)
        guard let node = try root.getPropertyByName("datetime") else {
            XCTFail()
            return
        }
        XCTAssertEqual(node.getType(), jsonNode.INT)
        guard let d = try node.getValueAsDatetime() else {
            XCTFail()
            return
        }
        guard let utcDate = stdlib.toutc(d) else {
            XCTFail()
            return
        }
        XCTAssertEqual(stdlib.millisecond(utcDate), 0)
        XCTAssertEqual(stdlib.second(utcDate), 1)
        XCTAssertEqual(stdlib.minute(utcDate), 11)
        XCTAssertEqual(stdlib.hour(utcDate), 5)
        XCTAssertEqual(stdlib.day(utcDate), 7)
        XCTAssertEqual(stdlib.month(utcDate), 10)
        XCTAssertEqual(stdlib.year(utcDate), 2022)
    }
    
    func testGetVValueAsIntegerString() throws {
        guard let root = try parser.parse(jsonSource4) else {
            XCTFail()
            return
        }
        XCTAssertEqual(root.getType(), jsonNode.OBJECT)
        guard let node = try root.getPropertyByName("bigint") else {
            XCTFail()
            return
        }
        XCTAssertEqual(node.getType(), jsonNode.INT)
        XCTAssertEqual(try node.getValueAsIntegerString(), "7151800870659686411")
    }
}

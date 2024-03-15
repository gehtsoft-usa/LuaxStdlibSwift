import Foundation

//@DocBrief("A Json node")
open class jsonNode: NSObject {
    public static let OBJECT: String? = "object";
    public static let ARRAY: String? = "array";
    public static let PROPERTY: String? = "property";
    public static let INT: String? = "int";
    public static let REAL: String? = "real";
    public static let STRING: String? = "string";
    public static let BOOLEAN: String? = "boolean";
    public static let NIL: String? = "nil";

    private var value: Any? = nil;
    private var type: String? = "undefined";
    private var name: String? = nil;


    public static func fromObject(_ obj: Any?, _ name: String?) -> jsonNode? {
        let node = jsonNode();
        node.value = obj;
        if (obj == nil) {
            node.type = jsonNode.NIL;
        } else if (name != nil) {
            node.name = name;
            node.type = jsonNode.PROPERTY;
        } else {
            node.type = jsonNode.getInnerType(obj);
        }
        return node;
    }


    private static func getInnerType(_ obj: Any?) -> String? {
        if obj is NSNull {
            return jsonNode.NIL
        }
        if obj is NSDictionary {
            return jsonNode.OBJECT
        }  
        if obj is NSArray {
            return jsonNode.ARRAY
        }  
        if obj is NSString {
            return jsonNode.STRING
        }  
        if let num = obj as? NSNumber {
            if jsonNode.isBoolNumber(num: num) {
                return jsonNode.BOOLEAN
            }
            if CFNumberIsFloatType(num) {
                return jsonNode.REAL
            }
            return jsonNode.INT
        }
        return "undefined"
    }

    private static func isBoolNumber(num: NSNumber) -> Bool
    {
        let boolID = CFBooleanGetTypeID() // the type ID of CFBoolean
        let numID = CFGetTypeID(num) // the type ID of num
        return numID == boolID
    }

    open func getType() -> String? {
        return type;
    }
    open func getName() throws -> String? {
        if (self.type != jsonNode.PROPERTY) {
            throw _exception_.create(0, "The node isn't a property")!
        }
        return self.name
    }
    open func getValueAsNode() throws -> jsonNode? {
        if (self.type != jsonNode.PROPERTY) {
            throw _exception_.create(0, "The node isn't a property")!
        }
        return jsonNode.fromObject(self.value, nil)
    }
    open func getValueAsString() throws -> String? {
        if (self.type != jsonNode.STRING) {
            throw _exception_.create(0, "The node isn't a string")!
        }
        if let str = self.value as? NSString {
            return String(str)
        }
        throw _exception_.create(0, "The node isn't a string")!
    }
    open func getValueAsInt() throws -> Int {
        if (self.type != jsonNode.INT) {
            throw _exception_.create(0, "The node isn't a int")!
        }
        if let num = self.value as? NSNumber {
            return num.intValue
        }
        throw _exception_.create(0, "The node isn't a int")!
    }
    open func getValueAsDatetime() throws -> Date? {
        if (self.type != jsonNode.INT) {
            throw _exception_.create(0, "The node isn't a int")!
        }
        if let num = self.value as? NSNumber {
            return Date(timeIntervalSince1970: num.doubleValue / 1000)
        }
        throw _exception_.create(0, "The node isn't a int")!
    }    
    open func getValueAsIntegerString() throws -> String? {
        if (self.type != jsonNode.INT) {
            throw _exception_.create(0, "The node isn't a int")!
        }
        if let num = self.value as? NSNumber {
            return num.stringValue
        }
        throw _exception_.create(0, "The node isn't a int")!
    }    
    open func getValueAsBoolean() throws -> Bool {
        if (self.type != jsonNode.BOOLEAN) {
            throw _exception_.create(0, "The node isn't a boolean")!
        }
        if let num = self.value as? NSNumber {
            return num.boolValue
        }
        throw _exception_.create(0, "The node isn't a boolean")!
    }
    open func getValueAsReal() throws -> Double {
        if (self.type != jsonNode.REAL) {
            throw _exception_.create(0, "The node isn't a real")!
        }
        if let num = self.value as? NSNumber {
            return num.doubleValue
        }
        throw _exception_.create(0, "The node isn't a real")!
    }
    open func getChildrenCount() throws -> Int {
        if let dict = self.value as? NSDictionary {
            return dict.count
        }  
        if let arr = self.value as? NSArray {
            return arr.count
        }  
        throw _exception_.create(0, "The node isn't an array or object")!
    }
    open func getChildByIndex(_ index : Int) throws -> jsonNode? {
        let count: Int = try self.getChildrenCount()
        if (index >= count) {
            throw _exception_.create(0, "Index exceeds array size")!
        }
        if (self.type == jsonNode.ARRAY) {
            if let arr = self.value as? NSArray {
                return jsonNode.fromObject(arr[index], nil)
            }
        }
        if (self.type == jsonNode.OBJECT) {
            if let dict = self.value as? NSDictionary {
                var n = 0
                for (key, value) in dict {
                    if (n == index) {
                        return jsonNode.fromObject(value, (key as? String))
                    }
                    n = n + 1
                }
            }
        }
        throw _exception_.create(0, "The node isn't an array or object")!
    }
    open func getPropertyByName(_ propertyName : String?) throws -> jsonNode? {
        if (self.type == jsonNode.OBJECT) {
            if let dict = self.value as? NSDictionary {
                return jsonNode.fromObject(dict[propertyName ?? ""], nil)
            }
        }
        throw _exception_.create(0, "The node isn't an  object")!
    }
}

import Foundation

public typealias variant = Variant

public enum VariantError: Error {
    case unsupportedType
    case wrongVariantType(Any?)
}

//@DocBrief("The class to convert any primitive type into an object")
//@DocDescription("Use the regular `cast` to create an instance of the `variant` object.")
//@DocDescription("To convert `nil` constant to a `variant`, first cast `nil` to `object`.")
public class Variant: NSObject {

    static let numberFormatter: NumberFormatter = {
        let result = NumberFormatter()
        result.decimalSeparator = "."
        return result
    }()

    static let dateFormatter: DateFormatter = {
        return DateFormatter()
    }()

    private enum VariantType: String {
        case date = "Date"
        case string = "String"
        case integer = "Integer"
        case double = "Double"
        case boolean = "Boolean"
        case object = "Object"
    }

    private final var data: Any?

    public init(_ data: Any?) {
        self.data = data
    }

    public func equals(_ obj: Any) -> Bool {
        if let variant = obj as? Variant {
            if variant.data == nil && data == nil { return true }
            guard let data = data else { return false }
            if let int = variant.data as? Int {
                if let ownInt = data as? Int {
                    return int == ownInt
                }
                if let double = data as? Double {
                    return Double(int) == double
                }
            }
            if let double = variant.data as? Double {
                if let ownDouble = data as? Double {
                    return double == ownDouble
                }
                if let ownInt = data as? Int {
                    return double == Double(ownInt)
                }
            }
            if let string = variant.data as? String {
                if let ownString = data as? String { return string == ownString }
            }
            if let date = variant.data as? Date {
                if let ownDate = data as? Date { return date == ownDate }
            }
            return false
        }

        guard let data = data else { return false }
        if let int = data as? Int {
            if let foreignInt = obj as? Int { return int == foreignInt }
            if let double = obj as? Double { return Double(int) == double }
        }
        if let double = data as? Double {
            if let foreignDouble = obj as? Double { return double == foreignDouble }
        }
        if let string = data as? String {
            if let foreignString = obj as? String { return string == foreignString }
        }
        if let date = data as? Date {
            if let foreignDate = obj as? Date { return date == foreignDate }
        }

        return false
    }

    public func type() -> String? {
        if data is Int { return VariantType.integer.rawValue }
        if data is Double { return VariantType.double.rawValue }
        if data is Date { return VariantType.date.rawValue }
        if data is String { return VariantType.string.rawValue }
        if data is Bool { return VariantType.boolean.rawValue }
        if data is NSObject { return VariantType.object.rawValue }
        return nil
    }
    public func asInt() throws -> Int {
        if let int = data as? Int { return int }
        if let double = data as? Double { return Int(double) }
        if let string = data as? String {
            if string.count == 0 {
                return 0;
            }
            guard let result = Variant.numberFormatter.number(from: string) else {
                throw VariantError.wrongVariantType(data)
            }
            return result.intValue
        }
        throw VariantError.wrongVariantType(data)
    }

    public func asReal() throws -> Double {
        if let double = data as? Double { return double }
        if let int = data as? Int { return Double(int) }
        if let string = data as? String {
            if string.count == 0 {
                return 0.0;
            }
            guard let result = Variant.numberFormatter.number(from: string) else {
                throw VariantError.wrongVariantType(data)
            }
            return result.doubleValue
        }

        throw VariantError.wrongVariantType(data)
    }

    public func asDatetime() -> Date? {
        data as? Date
    }

    public func asBoolean() throws -> Bool {
        if let bool = data as? Bool { return bool }
        if let string = data as? String {
            if string.lowercased() == "true" { return true }
            if string.lowercased() == "false" { return false }
            if string == "1" { return true }
            if string == "0" { return false }
        }
        throw VariantError.wrongVariantType(data)
    }

    public func asString() -> String? {
        if let string = data as? String { return string }
        if let int = data as? Int { return String(int) }
        if let double = data as? Double { return String(double) }
        if let date = data as? Date {
            return Variant.dateFormatter.string(from: date)
        }
        if let data = data { return "\(data)" }
        return nil
    }

    public func asObject() -> NSObject? {
        data as? NSObject
    }

    public func isInt() -> Bool {
        data as? Int != nil
    }

    public func isReal() -> Bool {
        data as? Double != nil
    }

    public func isDatetime() -> Bool {
        data is Date
    }

    public func isBoolean() -> Bool {
        data is Bool
    }

    public func isString() -> Bool {
        data is String
    }

    public func isObject() -> Bool {
        data is NSObject
    }

}

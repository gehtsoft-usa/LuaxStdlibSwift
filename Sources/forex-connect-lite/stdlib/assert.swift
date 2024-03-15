import Foundation

public typealias _assert_ = Assert

public enum AssertError {
    case isNotTrue(String)
    case isNotFalse(String)
    case isNotApproximatelyEquals(String)
    case doesNotThrow(String?)
    case doesThrow(Error, String?)
    case isNotString(String)
    case isNotXml(String)
    case isNotDifferent(String)
    case isNotEqual(String)
    case isNotGreater(String)
    case isNotGreaterOrEqual(String)
    case isNotLess(String)
    case isNotLessOrEqual(String)
    case wrongBoolComparison
    case wrongObjectComparison
    case wrongPattern
    case isNotMatch(String?)
    case isNotDoesntMatch(String?)

    var exception: _exception_? {
        switch self {
            case .isNotTrue(let text):
                return _exception_.create(0, "isNotTrue:" + text)
            case .isNotFalse(let text):
                return _exception_.create(0, "isNotFalse:" + text)
            case .isNotApproximatelyEquals(let text):
                return _exception_.create(0, "isNotApproximatelyEquals: " + text)
            case .doesNotThrow(let text):
                return _exception_.create(0, "isNotApproximatelyEquals: " + (text ?? ""))
            case .doesThrow(let error, let text):
                return _exception_.create(0, "isNotApproximatelyEquals: " + error.localizedDescription + " : " + (text ?? ""))
            case .isNotString(let text):
                return _exception_.create(0, "isNotString: " + text)
            case .isNotXml(let text):
                return _exception_.create(0, "isNotXml: " + text)
            case .isNotDifferent(let text):
                return _exception_.create(0, "isNotDifferent: " + text)
            case .isNotEqual(let text):
                return _exception_.create(0, "isNotEqual: " + text)
            case .isNotGreater(let text):
                return _exception_.create(0, "isNotGreater: " + text)
            case .isNotGreaterOrEqual(let text):
                return _exception_.create(0, "isNotGreaterOrEqual: " + text)
            case .isNotLess(let text):
                return _exception_.create(0, "isNotLess: " + text)
            case .isNotLessOrEqual(let text):
                return _exception_.create(0, "isNotLessOrEqual: " + text)
            case .wrongBoolComparison:
                return _exception_.create(0, "wrongBoolComparison")
            case .wrongObjectComparison:
                return _exception_.create(0, "wrongObjectComparison")
            case .wrongPattern:
                return _exception_.create(0, "wrongPattern")
            case .isNotMatch(let text):
                return _exception_.create(0, "isNotMatch: " + (text ?? ""))
            case .isNotDoesntMatch(let text):
                return _exception_.create(0, "isNotDoesntMatch: " + (text ?? ""))
        }
    } 
}

fileprivate enum ComparisonType {
    case equal
    case notEqual
    case greater
    case greaterOrEqual
    case less
    case lessOrEqual

    func compare<T>(_ value1: T, _ value2: T) -> Bool
            where T: Comparable {
        switch self {
        case .equal:
            return value1 == value2
        case .notEqual:
            return value1 != value2
        case .greater:
            return value1 > value2
        case .greaterOrEqual:
            return value1 >= value2
        case .less:
            return value1 < value2
        case .lessOrEqual:
            return value1 <= value2
        }
    }
}

fileprivate enum ErrorInType {
    case integer
    case double
    case date
    case string
    case bool
    case object
    case differentTypes
}

//@DocBrief("The library of assertions")
public class Assert: NSObject {

    // MARK: bool

    public static func isTrue(_ condition : Bool, _ message : String?) throws -> Void {
        if !condition {
            var resultMessage: String
            if let message = message,
               !message.isEmpty {
                resultMessage = " because \(message)"
            } else {
                resultMessage = ""
            }
            throw AssertError.isNotTrue(resultMessage).exception!
            
        }
    }

    public static func isFalse(_ condition : Bool, _ message : String?) throws -> Void {
        if condition {
            var resultMessage: String
            if let message = message,
               !message.isEmpty {
                resultMessage = " because \(message)"
            } else {
                resultMessage = ""
            }
            throw AssertError.isNotFalse(resultMessage).exception!
            
        }
    }

    // MARK: throws

    public static func _throws_(_ action : action?, _ message : String?) throws-> Void {
        let thrown: Bool
        do {
            try action?.invoke()
            thrown = false
        } catch {
            print(error)
            thrown = true
        }
        if !thrown {
            throw AssertError.doesNotThrow(message).exception!
        }
    }

    public static func doesNotThrow(_ action : action?, _ message : String?) throws -> Void {
        do {
            try action?.invoke()
        } catch {
            throw AssertError.doesThrow(error, message).exception!
        }
    }

    // MARK: approximately

    public static func approximatelyEquals(_ value : Double, _ expected : Double, _ delta : Double, _ message : String?) throws -> Void {
        guard fabs(value - expected) < delta else {
            var resultMessage: String
            if let message = message,
               !message.isEmpty {
                resultMessage = " because \(message)"
            } else {
                resultMessage = ""
            }
            throw AssertError.isNotApproximatelyEquals("Expected the value to be \(expected)±\(delta) but it's \(value)\(resultMessage)").exception!
        }
    }

    // MARK: xml

    public static func equalsXML(_ v1 : Any, _ v2 : Any, _ message : String?) throws -> Void {
        var args = [String]()

        var string1: String! = v1 as? String
        if string1 == nil {
            if let variant1 = v1 as? variant,
               variant1.isString() {
                string1 = variant1.asString()
            }
            if string1 == nil {
                args.append("argument 1")
            }
        }

        var string2: String! = v1 as? String
        if string2 == nil {
            if let variant2 = v2 as? variant,
               variant2.isString() {
                string2 = variant2.asString()
            }
            if string2 == nil {
                args.append("argument 1")
            }
        }

        try equalsXML(xml1: string1, xml2: string2, message: message)
    }

    // MARK: comparing

    public static func equals(_ v1 : Any?, _ v2 : Any?, _ message : String?) throws -> Void {
        if v1 == nil && v2 == nil { return }
        guard let v1 = v1,
              let v2 = v2 else {
            throw AssertError.isNotEqual(composedMessage("nil and filled value are different", message)).exception!
        }
        guard let comparingError = try compare(value1: v1, value2: v2, comparisonType: .equal) else { return }
        switch comparingError {
        case .object:
            throw AssertError.isNotEqual(composedMessage("object values are different", message)).exception!
        case .integer:
            throw AssertError.isNotEqual(composedMessage("int values are different", message)).exception!
        case .double:
            throw AssertError.isNotEqual(composedMessage("double values are different", message)).exception!
        case .date:
            throw AssertError.isNotEqual(composedMessage("date values are different", message)).exception!
        case .string:
            throw AssertError.isNotEqual(composedMessage("string values are different", message)).exception!
        case .bool:
            throw AssertError.isNotEqual(composedMessage("bool values are different", message)).exception!
        case .differentTypes:
            throw AssertError.isNotEqual(composedMessage("types are not match or values are empty", message)).exception!
        }
    }

    public static func doesNotEqual(_ v1 : Any?, _ v2 : Any?, _ message : String?) throws -> Void {
        if v1 == nil && v2 == nil {
            throw AssertError.isNotEqual(composedMessage("nil values are not different", message)).exception!
        }
        if let v1 = v1,
           let v2 = v2 {
            let comparingError = try compare(value1: v1, value2: v2, comparisonType: .notEqual)
            switch comparingError {
            case .object:
                throw AssertError.isNotEqual(composedMessage("object values are different", message)).exception!
            case .integer:
                throw AssertError.isNotDifferent(composedMessage("int values are not different", message)).exception!
            case .double:
                throw AssertError.isNotDifferent(composedMessage("double values are nt different", message)).exception!
            case .date:
                throw AssertError.isNotDifferent(composedMessage("date values are not different", message)).exception!
            case .string:
                throw AssertError.isNotDifferent(composedMessage("string values are not different", message)).exception!
            case .bool:
                throw AssertError.isNotDifferent(composedMessage("bool values are not different", message)).exception!
            case .differentTypes:
                break
            case .none:
                break
            }
        }
    }

    public static func greater(_ value : Any?, _ expected : Any?, _ message : String?) throws -> Void {
        guard let value = value,
              let expected = expected else {
            throw AssertError.isNotEqual(composedMessage("can't compare nil values", message)).exception!
        }
        let comparingError = try compare(value1: value, value2: expected, comparisonType: .greater)
        switch comparingError {
        case .object:
            throw AssertError.wrongObjectComparison.exception!
        case .integer:
            throw AssertError.isNotGreater(composedMessage("int value is not greater than expected", message)).exception!
        case .double:
            throw AssertError.isNotGreater(composedMessage("double value is not greater than expected", message)).exception!
        case .date:
            throw AssertError.isNotGreater(composedMessage("date value is not greater than expected", message)).exception!
        case .string:
            throw AssertError.isNotGreater(composedMessage("string value is not greater than expected", message)).exception!
        case .bool:
            throw AssertError.wrongBoolComparison.exception!
        case .differentTypes:
            throw AssertError.isNotGreater(composedMessage("types are not match or values are empty", message)).exception!
        case .none:
            break
        }
    }

    public static func greaterOrEqual(_ value : Any?, _ expected : Any?, _ message : String?) throws -> Void {
        guard let value = value,
              let expected = expected else {
            throw AssertError.isNotEqual(composedMessage("can't compare nil values", message)).exception!
        }
        let comparingError = try compare(value1: value, value2: expected, comparisonType: .greaterOrEqual)
        switch comparingError {
        case .object:
            throw AssertError.wrongObjectComparison.exception!
        case .integer:
            throw AssertError.isNotGreaterOrEqual(composedMessage("int value is not greater or equal than expected", message)).exception!
        case .double:
            throw AssertError.isNotGreaterOrEqual(composedMessage("double value is not greater or equal than expected", message)).exception!
        case .date:
            throw AssertError.isNotGreaterOrEqual(composedMessage("date value is not greater or equal than expected", message)).exception!
        case .string:
            throw AssertError.isNotGreaterOrEqual(composedMessage("string value is not greater or equal than expected", message)).exception!
        case .bool:
            throw AssertError.wrongBoolComparison.exception!
        case .differentTypes:
            throw AssertError.isNotGreaterOrEqual(composedMessage("types are not match or values are empty", message)).exception!
        case .none:
            break
        }
    }

    public static func less(_ value : Any?, _ expected : Any?, _ message : String?) throws -> Void {
        guard let value = value,
              let expected = expected else {
            throw AssertError.isNotEqual(composedMessage("can't compare nil values", message)).exception!
        }
        let comparingError = try compare(value1: value, value2: expected, comparisonType: .less)
        switch comparingError {
        case .object:
            throw AssertError.wrongObjectComparison.exception!
        case .integer:
            throw AssertError.isNotLess(composedMessage("int value is not less than expected", message)).exception!
        case .double:
            throw AssertError.isNotLess(composedMessage("double value is not less than expected", message)).exception!
        case .date:
            throw AssertError.isNotLess(composedMessage("date value is not less than expected", message)).exception!
        case .string:
            throw AssertError.isNotLess(composedMessage("string value is not less than expected", message)).exception!
        case .bool:
            throw AssertError.wrongBoolComparison.exception!
        case .differentTypes:
            throw AssertError.isNotLess(composedMessage("types are not match or values are empty", message)).exception!
        case .none:
            break
        }
    }

    public static func lessOrEqual(_ value : Any?, _ expected : Any?, _ message : String?) throws -> Void {
        guard let value = value,
              let expected = expected else {
            throw AssertError.isNotEqual(composedMessage("can't compare nil values", message)).exception!
        }
        let comparingError = try compare(value1: value, value2: expected, comparisonType: .lessOrEqual)
        switch comparingError {
        case .object:
            throw AssertError.wrongObjectComparison.exception!
        case .integer:
            throw AssertError.isNotLessOrEqual(composedMessage("int value is not less or equal than expected", message)).exception!
        case .double:
            throw AssertError.isNotLessOrEqual(composedMessage("double value is not less or equal than expected", message)).exception!
        case .date:
            throw AssertError.isNotLessOrEqual(composedMessage("date value is not less or equal than expected", message)).exception!
        case .string:
            throw AssertError.isNotLessOrEqual(composedMessage("string value is not less or equal than expected", message)).exception!
        case .bool:
            throw AssertError.wrongBoolComparison.exception!
        case .differentTypes:
            throw AssertError.isNotLessOrEqual(composedMessage("types are not match or values are empty", message)).exception!
        case .none:
            break
        }
    }

    // MARK: matching

    public static func matches(_ value : String?, _ pattern : String?, _ message : String?) throws -> Void {
        guard let value = value else {
            throw AssertError.isNotMatch(message).exception!
        }
        let (pattern, options) = try extractPatternAndOptions(from: pattern)
        let regularExpression = try NSRegularExpression(pattern: pattern, options: options)
        let string = value as NSString
        guard regularExpression.matches(in: value, range: NSRange(location: 0, length: string.length)).count > 0 else {
            throw AssertError.isNotMatch(message).exception!
        }
    }

    public static func doesNotMatch(_ value : String?, _ pattern : String?, _ message : String?) throws -> Void {
        guard let value = value else {
            throw AssertError.isNotDoesntMatch(message).exception!
        }
        let (pattern, options) = try extractPatternAndOptions(from: pattern)
        let regularExpression = try NSRegularExpression(pattern: pattern, options: options)
        let string = value as NSString
        guard regularExpression.matches(in: value, range: NSRange(location: 0, length: string.length)).isEmpty else {
            throw AssertError.isNotDoesntMatch(message).exception!
        }
    }

    // MARK: private

    private static func compareChildren(node1: xmlNode, node2: xmlNode) -> [String] {
        var result = [String]()

        if node1.getChildrenCount() == node2.getChildrenCount() {
            for index1 in 0..<node1.getChildrenCount() {
                guard let child1 = node1.getChild(index1) else {
                    result.append("can't get node1 child \(index1)")
                    continue
                }

                var childResults = [String]()
                for index2 in 0..<node2.getChildrenCount() {
                    guard let child2 = node2.getChild(index2) else {
                        childResults.append("can't get node2 child \(index2)")
                        continue
                    }
                    let result = differencesInNodes(node1: child1, node2: child2)
                    if result.isEmpty {
                        childResults.removeAll()
                        break
                    } else {
                        childResults.append(contentsOf: result)
                    }
                }

                result.append(contentsOf: childResults)
            }
        } else {
            result.append("elements' children count are not equal")
        }

        return result
    }

    private static func compareAttributes(node1: xmlNode, node2: xmlNode) -> [String] {
        var result = [String]()

        if node1.getAttributesCount() == node2.getAttributesCount() {
            for index1 in 0..<node1.getAttributesCount() {
                guard let attribute1 = node1.getAttribute(index1) else {
                    result.append("can't get node1 attribute \(index1)")
                    continue
                }

                var attributeResults = [String]()
                for index2 in 0..<node2.getAttributesCount() {
                    guard let attribute2 = node2.getAttribute(index2) else {
                        attributeResults.append("can't get node2 attribute \(index2)")
                        continue
                    }
                    let result = differencesInNodes(node1: attribute1, node2: attribute2)
                    if result.isEmpty {
                        attributeResults.removeAll()
                        break
                    } else {
                        attributeResults.append(contentsOf: result)
                    }
                }

                result.append(contentsOf: attributeResults)
            }
        } else {
            result.append("elements' attributes count are not equal")
        }

        return result
    }

    private static func differencesInNodes(node1: xmlNode, node2: xmlNode) -> [String] {
        var result = [String]()
        if node1.getType() != node2.getType() { result.append("node types are not equal") }
        switch node1.getType() {
        case XmlNode.ELEMENT:
            if node1.getName() == nil ||
                       node1.getName() != node2.getName() ||
                       node1.getLocalName() != node2.getLocalName() ||
                       node1.getNamespaceURI() != node2.getNamespaceURI() {
                result.append("elements' names are empty or not equal")
            }

            result.append(contentsOf: compareChildren(node1: node1, node2: node2))
            result.append(contentsOf: compareAttributes(node1: node1, node2: node2))

        case XmlNode.TEXT:
            if node1.getValue() == nil ||
                       node1.getValue() != node2.getValue() {
                result.append("text value is empty or not equal")
            }
        case XmlNode.CDATA:
            if node1.getValue() == nil ||
                       node1.getValue() != node2.getValue() {
                result.append("cdata value is empty or not equal")
            }
        case XmlNode.ATTRIBUTE:
            if node1.getName() == nil ||
                       node1.getValue() == nil ||
                       node1.getName() != node2.getName() ||
                       node1.getValue() != node2.getValue() {
                result.append("attribute name and value are empty or not equal")
            }
        default:
            break
        }

        return result
    }

    private static func equalsXML(xml1: String, xml2: String, message: String?) throws {
        let parser = XmlParser()

        var args = [String]()
        let node1: xmlNode! = try parser.parse(xml1)
        let node2: xmlNode! = try parser.parse(xml2)

        if node1 == nil { args.append("argument 1") }
        if node2 == nil { args.append("argument 2") }

        if args.count > 0 {
            throw AssertError.isNotXml(args.joined(separator: ",")).exception!
        }

        var result = differencesInNodes(node1: node1, node2: node2)
        if let message = message,
           !message.isEmpty {
            result.insert(message, at: 0)
        }
        guard result.isEmpty else {
            throw AssertError.isNotEqual(result.joined(separator: "\n")).exception!
        }
    }

    private static func compare(value1: Any, value2: Any, comparisonType: ComparisonType) throws -> ErrorInType? {
        if let variant1 = value1 as? variant,
           let variant2 = value2 as? variant {
            return try compare(variant1: variant1, variant2: variant2, comparisonType: comparisonType)
        }

        if let string1 = value1 as? String,
           let string2 = value2 as? String {
            if comparisonType.compare(string1, string2) { return nil }
            else { return .string }
        }

        if let int1 = value1 as? Int,
           let int2 = value2 as? Int {
            if comparisonType.compare(int1, int2) { return nil }
            else { return .integer }
        }

        if let double1 = value1 as? Double,
           let double2 = value2 as? Double {
            if comparisonType.compare(double1, double2) { return nil }
            else { return .double }
        }

        if let double1 = value1 as? Double,
           let int2 = value2 as? Int {
            if comparisonType.compare(double1, Double(int2)) { return nil }
            else { return .double }
        }

        if let int1 = value1 as? Int,
           let double2 = value2 as? Double {
            if comparisonType.compare(Double(int1), double2) { return nil }
            else { return .double }
        }

        if let date1 = value1 as? Date,
           let date2 = value2 as? Date {
            if comparisonType.compare(date1.timeIntervalSince1970, date2.timeIntervalSince1970) { return nil }
            else { return .date }
        }

        return .differentTypes
    }

    private static func compare(variant1: variant, variant2: variant, comparisonType: ComparisonType) throws -> ErrorInType? {
        if variant1.isInt() && variant2.isInt() {
            if let int1 = try? variant1.asInt(),
               let int2 = try? variant2.asInt(),
               comparisonType.compare(int1, int2) {
                return nil
            } else {
                return .integer
            }
        }
        if variant1.isReal() && variant2.isReal() {
            if let real1 = try? variant1.asReal(),
               let real2 = try? variant2.asReal(),
               comparisonType.compare(real1, real2) {
                return nil
            } else {
                return .double
            }
        }
        if variant1.isReal() && variant2.isInt() {
            if let real1 = try? variant1.asReal(),
               let int2 = try? variant2.asInt(),
               comparisonType.compare(real1, Double(int2)) {
                return nil
            } else {
                return .double
            }
        }
        if variant1.isInt() && variant2.isReal() {
            if let int1 = try? variant1.asInt(),
               let real2 = try? variant2.asReal(),
               comparisonType.compare(Double(int1), real2) {
                return nil
            } else {
                return .double
            }
        }

        if variant1.isDatetime() && variant2.isDatetime() {
            if let date1 = variant1.asDatetime(),
               let date2 = variant2.asDatetime(),
               comparisonType.compare(date1, date2) {
                return nil
            } else {
                return .date
            }
        }
        if variant1.isBoolean() && variant2.isBoolean() {
            if let bool1 = try? variant1.asBoolean(),
               let bool2 = try? variant2.asBoolean() {
                switch comparisonType {
                case .equal:
                    return bool1 == bool2 ? nil : .bool
                case .notEqual:
                    return bool1 != bool2 ? nil : .bool
                case .greater,
                     .greaterOrEqual,
                     .less,
                     .lessOrEqual:
                    throw AssertError.wrongBoolComparison.exception!
                }
            } else {
                return .bool
            }
        }
        if variant1.isString() && variant2.isString() {
            if let string1 = variant1.asString(),
               let string2 = variant2.asString(),
               comparisonType.compare(string1, string2) {
                return nil
            } else {
                return .string
            }
        }
        if variant1.isObject() && variant2.isObject() {
            if let obj1 = variant1.asObject(),
               let obj2 = variant2.asObject() {
                switch comparisonType {
                case .equal:
                    return obj1 === obj2 ? nil : .object
                case .notEqual:
                    return obj1 !== obj2 ? nil : .object
                case .greater,
                     .greaterOrEqual,
                     .less,
                     .lessOrEqual:
                    throw AssertError.wrongBoolComparison.exception!
                }
            } else {
                return .object
            }
        }
        return .differentTypes
    }

    private static func extractPatternAndOptions(from patternWithOptions: String?) throws -> (pattern: String, options: NSRegularExpression.Options) {
        guard let patternWithOptions = patternWithOptions else {
            throw AssertError.wrongPattern.exception!
        }
        let patternRegularExpression = try NSRegularExpression(pattern: "\\/(.+)\\/(\\w+)?")
        let nsPattern = patternWithOptions as NSString

        guard let match = patternRegularExpression.firstMatch(in: patternWithOptions, range: NSRange(location: 0, length: nsPattern.length)),
              match.numberOfRanges >= 2 else {
            throw AssertError.wrongPattern.exception!
        }

        let pattern = nsPattern.substring(with: match.range(at: 1))
        var options: NSRegularExpression.Options = []

        if match.numberOfRanges > 2 {
            let range = match.range(at: 2)
            if range.location != NSNotFound {
                let optionsString = nsPattern.substring(with: range)

                if optionsString.contains("i") {
                    options.insert(.caseInsensitive)
                }
                if optionsString.contains("m") {
                    options.insert(.anchorsMatchLines)
                }
                if optionsString.contains("s") {
                    options.insert(.dotMatchesLineSeparators)
                }
                if optionsString.contains("u") {
                    options.insert(.useUnicodeWordBoundaries)
                }
            }
        }
        return (pattern: pattern, options: options)
    }

    private static func composedMessage(_ message1: String, _ message2: String?) -> String {
        if let message2 = message2,
           !message2.isEmpty {
            return "\(message1): \(message2)"
        }
        return message1
    }

}

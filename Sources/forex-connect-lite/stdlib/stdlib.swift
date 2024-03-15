import Foundation

public typealias stdlib = StdLib

fileprivate extension Double {

    var getCeil: Double { ceil(self) }
    var getFloor: Double { floor(self) }
    var getLog: Double { log(self) }
    var getLog10: Double { log10(self) }
}

fileprivate func printLog(message: String) {
    print(message)
}

public enum StdLibError: Error {
    case argumentIsNil
}

//@DocBrief("The library of standard math, string and date functions")
public class StdLib: NSObject {

    public static let PI: Double = 3.141592653589793;
    public static let E: Double = 2.718281828459045;

    public static func len(_ s : String?) -> Int {
        s?.count ?? 0
    }

    public static func indexOf(_ s : String?, _ sub : String?, _ caseSensitive : Bool) -> Int {
        guard let s = s,
              let sub = sub,
              let range = s.range(of: sub, options: caseSensitive ? [] : .caseInsensitive, locale: .current) else {
            return -1
        }
        return s.distance(from: s.startIndex, to: range.lowerBound)
    }

    public static func lastIndexOf(_ s : String?, _ sub : String?, _ caseSensitive : Bool) -> Int {
        guard let s = s,
              let sub = sub else {
            return -1
        }
        let options: NSString.CompareOptions
        if caseSensitive {
            options = .backwards
        } else {
            options = [.backwards, .caseInsensitive]
        }
        guard let range = s.range(of: sub, options: options, locale: .current) else {
            return -1
        }
        return s.distance(from: s.startIndex, to: range.lowerBound)
    }

    public static func compareStrings(_ a : String?, _ b : String?, _ caseSensitive : Bool) -> Int {
        guard let a = a,
              let b = b else {
            return 0
        }

        let string1, string2: String
        if caseSensitive {
            string1 = a
            string2 = b
        } else {
            string1 = a.uppercased(with: .current)
            string2 = b.uppercased(with: .current)
        }
        if string1 > string2 {
            return 1
        } else if string1 < string2 {
            return -1
        }
        return 0
    }

    public static func charIndex(_ s : String?, _ char : Int, _ startOffset : Int, _ caseSensitive : Bool) -> Int {
        guard let s = s,
              let unicodeScalar = UnicodeScalar(char) else {
            return -1
        }
        let char = Character(unicodeScalar)
        let startIndex = s.index(s.startIndex, offsetBy: startOffset)
        guard let range = s.range(of: "\(char)",
                                  options: caseSensitive ? [] : .caseInsensitive,
                                  range: startIndex..<s.endIndex,
                                  locale: .current) else {
            return -1
        }
        return s.distance(from: s.startIndex, to: range.lowerBound)
    }

    public static func lastCharIndex(_ s : String?, _ char : Int, _ startOffset : Int, _ caseSensitive : Bool) -> Int {
        guard let s = s,
              let unicodeScalar = UnicodeScalar(char) else {
            return -1
        }
        let char = Character(unicodeScalar)
        let startIndex = s.index(s.startIndex, offsetBy: startOffset)

        let options: NSString.CompareOptions
        if caseSensitive {
            options = .backwards
        } else {
            options = [.backwards, .caseInsensitive]
        }

        guard let range = s.range(of: "\(char)", options: options, range: startIndex..<s.endIndex, locale: .current) else {
            return -1
        }
        return s.distance(from: s.startIndex, to: range.lowerBound)
    }

    public static func upper(_ s : String?) -> String? {
        s?.uppercased(with: .current)
    }

    public static func lower(_ s : String?) -> String? {
        s?.lowercased(with: .current)
    }

    public static func left(_ s : String?, _ length : Int) -> String? {
        guard let s = s else { return nil }
        var length = length
        if length > s.count { length = s.count }
        let endIndex = s.index(s.startIndex, offsetBy: length)
        return String(s[s.startIndex..<endIndex])
    }

    public static func trim(_ s : String?) -> String? {
        s?.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    public static func rtrim(_ s : String?) -> String? {
        guard let s = s else { return nil }
        let reversed = String(s.reversed())
        let result = reversed.drop { $0.isWhitespace || $0.isNewline }
        return String(result.reversed())
    }

    public static func ltrim(_ s : String?) -> String? {
        guard let s = s else { return nil }
        return String(s.drop { $0.isWhitespace || $0.isNewline })
    }

    public static func right(_ s : String?, _ length : Int) -> String? {
        guard let s = s else { return nil }
        var length = length
        if length > s.count { length = s.count }
        let startIndex = s.index(s.startIndex, offsetBy: s.count - length)
        return String(s[startIndex..<s.endIndex])
    }

    public static func substring(_ s : String?, _ from : Int, _ length : Int) -> String? {
        guard let s = s else { return nil }
        var from = from
        if from < 0 { from = 0 }
        if from > s.count { from = s.count }

        var length = length
        if from + length > s.count { length = s.count - from }

        let startIndex = s.index(s.startIndex, offsetBy: from)
        let endIndex = s.index(s.startIndex, offsetBy: from + length)
        return String(s[startIndex..<endIndex])
    }

    public static func match(_ s : String?, _ re : String?) -> Bool {
        guard let s = s,
              let re = re else {
            return false
        }
        return s.range(of: re, options: .regularExpression, locale: .current) != nil
    }

    public static func unicode(_ s : String?, _ position : Int) -> Int {
        guard let s = s,
              position >= 0 && position < s.count else {
            return -1
        }
        let index = s.index(s.startIndex, offsetBy: position)
        let c = s.utf8[index]
        return Int(c)
    }

    public static func char(_ unicode : Int) -> String? {
        guard unicode > 0,
              let unicodeScalar = UnicodeScalar(unicode) else {
            return ""
        }
        return "\(unicodeScalar)"
    }

    public static func iabs(_ x : Int) -> Int {
        fatalError("'iabs' is not implemented yet.");
    }

    public static func isgn(_ x : Int) -> Int {
        fatalError("'isgn' is not implemented yet.");
    }

    public static func abs(_ x : Double) -> Double {
        fabs(x)
    }

    public static func sgn(_ x : Double) -> Int {
        fatalError("'sgn' is not implemented yet.");
    }

    public static func sin(_ x : Double) -> Double {
        fatalError("'sin' is not implemented yet.");
    }

    public static func cos(_ x : Double) -> Double {
        fatalError("'cos' is not implemented yet.");
    }

    public static func tan(_ x : Double) -> Double {
        fatalError("'tan' is not implemented yet.");
    }

    public static func asin(_ x : Double) -> Double {
        fatalError("'asin' is not implemented yet.");
    }

    public static func acos(_ x : Double) -> Double {
        fatalError("'acos' is not implemented yet.");
    }

    public static func atan(_ x : Double) -> Double {
        fatalError("'atan' is not implemented yet.");
    }

    public static func atan2(_ y : Double, _ x : Double) -> Double {
        fatalError("'atan2' is not implemented yet.");
    }

    public static func sqrt(_ x : Double) -> Double {
        x.squareRoot()
    }

    public static func ceil(_ x : Double) -> Double {
        x.getCeil
    }

    public static func floor(_ x : Double) -> Double {
        x.getFloor
    }

    public static func round(_ x : Double, _ digits : Int) -> Double {
        let divisor = pow(10.0, Double(digits))
        return (x / divisor).rounded() * divisor
    }

    public static func roundInl(_ x : Double, _ digits : Int) -> Double {
        var dMult = Double(1)
        for _ in 0..<digits {
            dMult *= 10
        }

        var val: Double = x * dMult
        if val < 0 {
            val = (val - 0.5).getCeil
        } else {
            val = (val + 0.5).getFloor
        }
        return val / dMult
    }

    public static func log(_ x : Double) -> Double {
        x.getLog
    }

    public static func log10(_ x : Double) -> Double {
        x.getLog10
    }

    public static func mkdate(_ year : Int, _ month : Int, _ day : Int) -> Date? {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        let components = DateComponents(calendar: calendar,
                                        year: year,
                                        month: month,
                                        day: day)
        return calendar.date(from: components) ?? Date(timeIntervalSince1970: 0)
    }

    public static func mkdatetime(_ year : Int, _ month : Int, _ day : Int, _ hour : Int, _ minute : Int, _ second : Int, _ milliseconds : Int) -> Date? {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        let components = DateComponents(calendar: calendar,
                                        year: year,
                                        month: month,
                                        day: day,
                                        hour: hour,
                                        minute: minute,
                                        second: second,
                                        nanosecond: milliseconds * 1000000)
        return calendar.date(from: components) ?? Date(timeIntervalSince1970: 0)
    }

    public static func day(_ x : Date?) -> Int {
        guard let x = x else { return -1 }
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        return calendar.component(.day, from: x)
    }

    public static func dayOfWeek(_ x : Date?) -> Int {
        guard let x = x else { return -1 }
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        return calendar.component(.weekday, from: x)
    }

    public static func month(_ x : Date?) -> Int {
        guard let x = x else { return -1 }
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        return calendar.component(.month, from: x)
    }

    public static func year(_ x : Date?) -> Int {
        guard let x = x else { return -1 }
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        return calendar.component(.year, from: x)
    }

    public static func leapYear(_ x : Date?) throws -> Bool {
        guard let x = x else {
            throw StdLibError.argumentIsNil
        }
        let year = year(x)
        if year % 400 == 0 {
            return true
        } else if year % 100 == 0 {
            return false
        } else {
            return year % 4 == 0
        }
    }

    public static func hour(_ x : Date?) -> Int {
        guard let x = x else { return -1 }
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        return calendar.component(.hour, from: x)
    }

    public static func minute(_ x : Date?) -> Int {
        guard let x = x else { return -1 }
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        return calendar.component(.minute, from: x)
    }

    public static func second(_ x : Date?) -> Int {
        guard let x = x else { return -1 }
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        return calendar.component(.second, from: x)
    }

    public static func seconds(_ x : Date?) -> Double {
        guard let x = x else { return -1 }
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        let second = calendar.component(.second, from: x)
        return Double(second) + Double(millisecond(x)) / 1000.0
    }

    public static func millisecond(_ x : Date?) -> Int {
        guard let x = x else { return -1 }
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        let nanosecond = Double(calendar.component(.nanosecond, from: x))
        return Int(round(nanosecond, 6) / 1000000.0)
    }

    public static func nowlocal() -> Date? {
        Date()
    }

    public static func nowutc() -> Date? {
       Date()
    }

    public static func toutc(_ x : Date?) -> Date? {
        x
    }

    public static func toJdn(_ x : Date?) -> Double {
        guard let x = x else { return -1 }
        return x.timeIntervalSince1970 / 86400.0 + Double(2440587.5)
    }

    public static func fromJdn(_ x : Double) -> Date? {
        let timeinterval = (x - Double(2440587.5)) * 86400.0
        return Date(timeIntervalSince1970: round(timeinterval, -3))
    }

    public static func print(_ x : String?) -> Void {
        guard let x = x else { return }
        printLog(message: x)
    }

}

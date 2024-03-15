import Foundation

public typealias csvParser = CsvParser

public enum CsvParserError: LocalizedError {
    case wrongValueSeparator
}

extension CsvParserError {

    public var errorDescription: String? {
        switch self {
        case .wrongValueSeparator:
            return "The value separator must be exactly one character"
        }
    }

}

//@DocBrief("The parser for CSV (comma-separated values) text format")
public class CsvParser: NSObject {
    public var valueSeparator: String? = nil;
    public var allowComments: Bool = false;
    public var commentPrefix: String? = nil;


    public override init() {
        allowComments = false;
        commentPrefix = "#";
        valueSeparator = ",";
    }

    public func splitLine(_ line : String?) throws -> [String?]? {
        guard let line = line else { return nil }
        guard let valueSeparator = valueSeparator,
              valueSeparator.count == 1 else { throw CsvParserError.wrongValueSeparator }

        if let commentPrefix = commentPrefix,
           allowComments && line.starts(with: commentPrefix) { 
            return nil
        }

        let valueSeparatorChar = valueSeparator[valueSeparator.startIndex]
        var stringBuilder = ""

        var values = [String]()
        for char in line {
            if valueSeparator == "\n" && char == "\r\n" {
                values.append(stringBuilder)
                stringBuilder = ""
            } else if char == valueSeparatorChar {
                values.append(stringBuilder)
                stringBuilder = ""
            } else {
                stringBuilder.append(char)
            }
        }
        values.append(stringBuilder)
        return values
    }

}

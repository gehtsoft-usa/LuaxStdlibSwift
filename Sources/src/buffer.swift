import Foundation

public typealias buffer = Buffer

enum BufferError: Error {
    case wrongBufferLength
    case indexOutOfBounds
    case cannotEncode
    case cannotDecode
    case canNotCreateFromBase64String
    case invalidHexString
    case argumentIsNilOrEmpty
}

//@DocBrief("The buffer of bytes")
public class Buffer: NSObject {

    private(set) var data: Data

    public init(data: Data) {
        self.data = data
    }

    public func getData() -> Data {
        return self.data;
    }

    public func length() -> Int {
        data.count
    }

    public func get(_ index : Int) -> Int {
        fatalError("'get' is not implemented yet.");
    }

    public func set(_ index : Int, _ value : Int) -> Void {
        fatalError("'set' is not implemented yet.");
    }

    public func getInt16(_ index : Int) -> Int {
        fatalError("'getInt16' is not implemented yet.");
    }

    public func setInt16(_ index : Int, _ value : Int) -> Int {
        fatalError("'setInt16' is not implemented yet.");
    }

    public func getInt32(_ index : Int) -> Int {
        fatalError("'getInt32' is not implemented yet.");
    }

    public func setInt32(_ index : Int, _ value : Int) -> Int {
        fatalError("'setInt32' is not implemented yet.");
    }

    public func getInt16B(_ index : Int) -> Int {
        fatalError("'getInt16B' is not implemented yet.");
    }

    public func setInt16B(_ index : Int, _ value : Int) -> Int {
        fatalError("'setInt16B' is not implemented yet.");
    }

    public func getInt32B(_ index : Int) -> Int {
        fatalError("'getInt32B' is not implemented yet.");
    }

    public func setInt32B(_ index : Int, _ value : Int) -> Int {
        fatalError("'setInt32B' is not implemented yet.");
    }

    public func getFloat32(_ index : Int) -> Double {
        fatalError("'getFloat32' is not implemented yet.");
    }

    public func setFloat32(_ index : Int, _ value : Double) -> Int {
        fatalError("'setFloat32' is not implemented yet.");
    }

    public func getFloat64(_ index : Int) -> Double {
        fatalError("'getFloat64' is not implemented yet.");
    }

    public func setFloat64(_ index : Int, _ value : Double) -> Int {
        fatalError("'setFloat64' is not implemented yet.");
    }

    public func getEncodedString(_ index : Int, _ encodedLength : Int, _ codePage : Int) throws -> String? {
        let range = try Buffer.range(from: index, length: encodedLength, in: data)
        let subdata = data.subdata(in: range)

        let encoding = try String.Encoding(codepage: codePage)
        guard let result = String(data: subdata, encoding: encoding) else {
            throw BufferError.cannotEncode
        }
        return result
    }

    public func setEncodedString(_ index : Int, _ value : String?, _ codePage : Int) throws -> Int {
        let encoding = try String.Encoding(codepage: codePage)
        guard let result = value?.data(using: encoding) else {
            throw BufferError.cannotDecode
        }

        if index < 0 || index >= data.count {
            throw BufferError.indexOutOfBounds
        }

        let startIndex = data.index(data.startIndex, offsetBy: index)
        if index + result.count > data.count {
            data.append(Data(count: index + result.count - data.count))
        }
        let endIndex = data.index(data.startIndex, offsetBy: index + (value?.count ?? 0))
        data.replaceSubrange(startIndex..<endIndex, with: result)

        return result.count
    }

    public func getUnicodeString(_ index : Int, _ maximumLength : Int) -> String? {
        fatalError("'getUnicodeString' is not implemented yet.");
    }

    public func setUnicodeString(_ index : Int, _ value : String?) -> Int {
        fatalError("'setUnicodeString' is not implemented yet.");
    }

    public static func getEncodedStringLength(_ value : String?, _ codePage : Int) throws -> Int {
        let encoding = try String.Encoding(codepage: codePage)
        guard let data = value?.data(using: encoding) else {
            throw BufferError.cannotDecode
        }
        return data.count
    }

    public func setBuffer(_ index : Int, _ value : buffer?, _ sourceIndex : Int, _ sourceLength : Int) throws -> Int {
        if index < 0 || index >= data.count {
            throw BufferError.indexOutOfBounds
        }

        guard let value = value else {
            throw BufferError.argumentIsNilOrEmpty
        }

        let range = try Buffer.range(from: sourceIndex, length: sourceLength, in: value.data)
        let insertingValue = value.data.subdata(in: range)

        let startIndex = data.index(data.startIndex, offsetBy: index)
        if index + insertingValue.count > data.count {
            data.append(Data(count: index + insertingValue.count - data.count))
        }
        let endIndex = data.index(data.startIndex, offsetBy: index + insertingValue.count)
        data.replaceSubrange(startIndex..<endIndex, with: insertingValue)

        return insertingValue.count
    }

    public func resize(_ newsize : Int) -> Void {
        if newsize > data.count {
            data.append(Data(count: newsize - data.count))
        } else if newsize < data.count {
            data.removeLast(data.count - newsize)
        }
    }

    public static func create(_ length : Int) throws -> buffer? {
        guard length >= 0 else {
            throw BufferError.wrongBufferLength
        }
        let data = Data(count: length)
        return Buffer(data: data)
    }

    public func toHexString() -> String? {
        data.reduce("") { $0 + String(format: "%02x", $1) }
    }

    public func toBase64() -> String? {
        data.base64EncodedString()
    }

    public static func fromHexString(_ v : String?) throws -> buffer? {
        guard let hexString = v else {
            throw BufferError.argumentIsNilOrEmpty
        }
        let length = hexString.count / 2
        var data = Data(capacity: length)
        var startIndex = hexString.startIndex
        for _ in 0..<length {
            let endIndex = hexString.index(startIndex, offsetBy: 2)
            let bytes = hexString[startIndex..<endIndex]
            if var number = UInt8(bytes, radix: 16) {
                data.append(&number, count: 1)
            } else {
                throw BufferError.invalidHexString
            }
            startIndex = endIndex
        }
        return Buffer(data: data)
    }

    public static func fromBase64(_ v : String?) throws -> buffer? {
        guard let string = v else {
            throw _exception_.create(0, "can not create from Base64 string")!
        }
        guard let data = Data(base64Encoded: string) else {
            throw _exception_.create(0, "can not create from Base64 string")!
        }
        return Buffer(data: data)
    }
    
    private static func range(from index: Int, length: Int? = nil, in data: Data) throws -> Range<Data.Index> {
        if index < 0 || index >= data.count {
            throw BufferError.indexOutOfBounds
        }
        let startIndex = data.index(data.startIndex, offsetBy: index)
        let endIndex: Data.Index
        if let length = length,
           index + length < data.count {
            endIndex = data.index(data.startIndex, offsetBy: index + length)
        } else {
            endIndex = data.endIndex
        }
        return startIndex..<endIndex
    }

}

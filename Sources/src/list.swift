import Foundation

public typealias _list_ = List

public enum ListError {
    case indexOutOfBounds(Int, Int)

    var exception: _exception_? {
        switch self {
        case .indexOutOfBounds(let index, let count):
            return _exception_.create(0, "Index \(index) out of bounds (should be in 0..<\(count)")
        }
    }
}

    //@DocBrief("The list of objects")
open class List: NSObject {

    private var data = [NSObject?]()

    public static func create(_ initial : inout [NSObject?]?) -> List? {
        let result = List()
        result.data = initial ?? []
        return result
    }

    public func length() -> Int {
        data.count
    }

    open func get(_ index : Int) throws -> NSObject? {
        guard index >= 0 && index < data.count else {
            throw ListError.indexOutOfBounds(index, data.count).exception!
        }
        return data[index]
    }

    open func set(_ index : Int, _ value : NSObject?) throws -> Void {
        guard index >= 0 && index < data.count else {
            throw ListError.indexOutOfBounds(index, data.count).exception!
        }
        data[index] = value
    }

    open func add(_ value : NSObject?) -> Void {
        data.append(value)
    }

    open func insert(_ index : Int, _ value : NSObject?) throws -> Void {
        guard index >= 0 && index < data.count else {
            throw ListError.indexOutOfBounds(index, data.count).exception!
        }
        data.insert(value, at: index)
    }

    open func remove(_ index : Int) throws -> Void {
        guard index >= 0 && index < data.count else {
            throw ListError.indexOutOfBounds(index, data.count).exception!
        }
        data.remove(at: index)
    }

    open func clear() -> Void {
        data.removeAll()
    }

    open func toArray() -> [NSObject?]? {
        data.map { $0 }
    }

}

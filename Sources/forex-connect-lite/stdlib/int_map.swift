import Foundation

public typealias int_map = IntMap

public enum IntMapError: Error {
    case notExists
}

//@DocBrief("The map of objects with an integer key")
public class IntMap: NSObject {

    private var map: [Int: NSObject]

    public override init() {
        map = [:]
    }

    public func length() -> Int {
        map.count
    }

    public func contains(_ key : Int) -> Bool {
        map[key] != nil
    }

    public func get(_ key : Int) throws -> NSObject? {
        guard let result = map[key] else {
            throw IntMapError.notExists
        }
        return result
    }

    public func set(_ key : Int, _ value : NSObject?) -> Void {
        map[key] = value
    }

    public func remove(_ key : Int) -> Void {
        let _ = map.removeValue(forKey: key)
    }

    public func keys() -> [Int]? {
        Array(map.keys)
    }

    public func clear() -> Void {
        map.removeAll()
    }

}

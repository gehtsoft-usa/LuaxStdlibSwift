import Foundation

public typealias string_map = StringMap

public enum StringMapError: Error {
    case notExists
}

//@DocBrief("The map of objects with an string key")
public class StringMap: NSObject {

    private var map: [String: NSObject?]

    public override init() {
        map = [:]
    }

    public func length() -> Int {
        map.count
    }

    public func contains(_ key : String?) -> Bool {
        guard let key = key else {
            return false
        }
        return map[key] != nil
    }

    public func get(_ key : String?) throws -> NSObject? {
        guard let key = key,
              let result = map[key] else {
            throw StringMapError.notExists
        }
        return result
    }

    public func set(_ key : String?, _ value : NSObject?) -> Void {
        guard let key = key else { return }
        map[key] = value
    }

    public func remove(_ key : String?) -> Void {
        guard let key = key else { return }
        let _ = map.removeValue(forKey: key)
    }

    public func keys() -> [String?]? {
        let result: [String?] = Array(map.keys)
        return result
    }

    public func clear() -> Void {
        map.removeAll()
    }
}

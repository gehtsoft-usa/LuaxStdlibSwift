import Foundation

public typealias queue = DataQueue

public enum DataQueueError: Error {
    case isEmpty
}

//@DocBrief("The queue of objects")
public class DataQueue: NSObject {

    private var elements: [NSObject?]

    public override init() {
        elements = []
    }

    public func length() -> Int {
        elements.count
    }

    public func enqueue(_ value : NSObject?) -> Void {
        elements.append(value)
    }

    public func peek() throws -> NSObject? {
        guard let first = elements.first else {
            throw DataQueueError.isEmpty
        }
        return first
    }

    public func dequeue() throws -> NSObject? {
        guard let first = elements.first else {
            throw DataQueueError.isEmpty
        }
        elements.removeFirst()
        return first
    }

    public func clear() -> Void {
        elements.removeAll()
    }

}

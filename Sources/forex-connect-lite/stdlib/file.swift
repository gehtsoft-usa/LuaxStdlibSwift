import Foundation

//@DocBrief("The read/write operations for a file")
public class file: NSObject {
    public func size() -> Int {
        fatalError("'size' is not implemented yet.");
    }
    public func position() -> Int {
        fatalError("'position' is not implemented yet.");
    }
    public func seek(_ position : Int) -> Void {
        fatalError("'seek' is not implemented yet.");
    }
    public func readLine() -> String? {
        fatalError("'readLine' is not implemented yet.");
    }
    public func readByte() -> Int {
        fatalError("'readByte' is not implemented yet.");
    }
    public func readBuffer(_ length : Int) -> buffer? {
        fatalError("'readBuffer' is not implemented yet.");
    }
    public func writeLine(_ v : String?) -> Void {
        fatalError("'writeLine' is not implemented yet.");
    }
    public func writeByte(_ v : Int) -> Void {
        fatalError("'writeByte' is not implemented yet.");
    }
    public func writeBuffer(_ v : buffer?, _ offset : Int, _ length : Int) -> Void {
        fatalError("'writeBuffer' is not implemented yet.");
    }
    public func close() -> Void {
        fatalError("'close' is not implemented yet.");
    }
    public func lock(_ offset : Int, _ length : Int) -> Void {
        fatalError("'lock' is not implemented yet.");
    }
    public func unlock(_ offset : Int, _ length : Int) -> Void {
        fatalError("'unlock' is not implemented yet.");
    }
}

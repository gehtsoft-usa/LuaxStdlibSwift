import Foundation

public typealias io = Io

public enum IoError: Error {
    case fileOrDirectoryNotExist
    case fileContentIsNotText
}

//@DocBrief("The library of filesystem functions")
public class Io: NSObject {
    public static let M_OPEN: Int = 1;
    public static let M_CREATE: Int = 2;
    public static let M_READ: Int = 16;
    public static let M_WRITE: Int = 32;
    public static let M_READWRITE: Int = 48;
    public static let M_SHARE_READ: Int = 64;
    public static let M_SHARE_WRITE: Int = 128;
    public static let M_SHARE: Int = 192;
    public static let CP_ANSI: Int = 437;
    public static let CP_UTF7: Int = 65000;
    public static let CP_UTF8: Int = 65001;

    private static let fileManager = FileManager.default

    public static func exists(_ filename : String?) -> Bool {
        guard let filename = filename,
              let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(
                .documentDirectory,
                .userDomainMask,
                true
        ).first else {
            return false
        }
        return fileManager.fileExists(atPath: "\(documentDirectoryPath)/\(filename)")
    }

    public static func size(_ filename : String?) throws -> Int {
        guard let filename = filename,
              let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(
                .documentDirectory,
                .userDomainMask,
                true
        ).first else {
            throw IoError.fileOrDirectoryNotExist
        }
        guard let attributes = try? fileManager.attributesOfItem(atPath: "\(documentDirectoryPath)/\(filename)"),
              let sizeAttribute = attributes[.size] as? NSNumber else {
            throw IoError.fileOrDirectoryNotExist
        }
        return sizeAttribute.intValue
    }

    public static func isFolder(_ filename : String?) throws -> Bool {
        guard let filename = filename,
              let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(
                .documentDirectory,
                .userDomainMask,
                true
        ).first else {
            throw IoError.fileOrDirectoryNotExist
        }
        var isDirectory: ObjCBool = false
        let exists = fileManager.fileExists(atPath: "\(documentDirectoryPath)/\(filename)", isDirectory: &isDirectory)
        if !exists { throw IoError.fileOrDirectoryNotExist }
        return isDirectory.boolValue == true
    }

    public static func isFile(_ filename : String?) throws -> Bool {
        guard let filename = filename,
              let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(
                .documentDirectory,
                .userDomainMask,
                true
        ).first else {
            throw IoError.fileOrDirectoryNotExist
        }
        var isDirectory: ObjCBool = false
        let exists = fileManager.fileExists(atPath: "\(documentDirectoryPath)/\(filename)", isDirectory: &isDirectory)
        if !exists { throw IoError.fileOrDirectoryNotExist }
        return isDirectory.boolValue == false
    }

    public static func files(_ path : String?) throws -> [String?]? {
        guard let path = path,
              let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(
                .documentDirectory,
                .userDomainMask,
                true
        ).first else {
            throw IoError.fileOrDirectoryNotExist
        }
        do {
            let content = try fileManager.contentsOfDirectory(atPath: "\(documentDirectoryPath)/\(path)")
            return content.filter { (try? isFile("\(path)/\($0)")) == true }
        } catch {
            throw IoError.fileOrDirectoryNotExist
        }
    }

    public static func folders(_ path : String?) throws -> [String?]? {
        guard let path = path,
              let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(
                .documentDirectory,
                .userDomainMask,
                true
        ).first else {
            throw IoError.fileOrDirectoryNotExist
        }
        do {
            let content = try fileManager.contentsOfDirectory(atPath: "\(documentDirectoryPath)/\(path)")
            return content.filter { (try? isFolder("\(path)/\($0)")) == true }
        } catch {
            throw IoError.fileOrDirectoryNotExist
        }
    }

    public static func delete(_ path : String?) throws -> Void {
        guard let path = path else {
            throw IoError.fileOrDirectoryNotExist
        }
        try fileManager.removeItem(atPath: path)
    }

    public static func writeTextToFile(_ path : String?, _ text : String?, _ codepage : Int) throws -> Void {
        guard let url = URL(string: "file://(path)") else {
            return
        }
        guard let fileContentToWrite = text?.data(using: try String.Encoding(codepage: codepage)) else {
            return
        }
        try fileContentToWrite.write(to: url)
    }

    public static func readTextFromFile(_ path : String?, _ codepage : Int) throws -> String? {
        guard let content = fileManager.contents(atPath: path!) else {
            throw IoError.fileOrDirectoryNotExist
        }
        guard let result = String(data: content, encoding: try String.Encoding(codepage: codepage)) else {
            throw IoError.fileContentIsNotText
        }
        return result
    }

    public static func tempFolder() -> String? {
        NSTemporaryDirectory()
    }

    public static func combinePath(_ p1 : String?, _ p2 : String?) -> String? {
        guard let p1 = p1,
              let p2 = p2 else {
            return nil
        }
        return "\(p1)/\(p2)"
    }

    public static func fullPath(_ p1 : String?) throws -> String? {
        guard let p1 = p1,
              let currentFolder = currentFolder() else {
            throw IoError.fileOrDirectoryNotExist
        }
        return "\(currentFolder)/\(p1)"
    }

    public static func currentFolder() -> String? {
        FileManager.default.currentDirectoryPath
    }

    public static func createFolder(_ name : String?) -> Void {
        fatalError("'createFolder' is not implemented yet.");
    }

    public static func open(_ filename : String?, _ mode : Int, _ codepage : Int) -> file? {
        fatalError("'open' is not implemented yet.");
    }

}

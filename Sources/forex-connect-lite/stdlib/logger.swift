import Foundation

public typealias logger = Logger

//@DocBrief("The logger class")
public class Logger: NSObject {

    public static func debug(_ message : String?) -> Void {
        if let message = message { print("🪲: \(message)") }
        else { print("🪲") }
    }

    public static func info(_ message : String?) -> Void {
        if let message = message { print("ℹ️: \(message)") }
        else { print("ℹ") }
    }

    public static func warning(_ message : String?) -> Void {
        if let message = message { print("⚠️: \(message)") }
        else { print("⚠️") }
    }

    public static func error(_ message : String?) -> Void {
        if let message = message { print("‼️: \(message)") }
        else { print("‼️") }
    }

    public static func fatal(_ message : String?) -> Void {
        if let message = message { print("💥💥 \(message) 💥💥") }
        else { print("💥💥") }
    }
}

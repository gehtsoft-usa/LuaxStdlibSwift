import Foundation

/// The interface to an action
public protocol action: AnyObject {
    /// The action method to be invoked
    func invoke() throws -> Void;
}

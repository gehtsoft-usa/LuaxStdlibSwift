import Foundation

/// Callback class for processing HTTP response
open class httpResponseCallback: NSObject {
    /// The action method to be invoked on request finished
    ///
    /// - Parameter status: The status code
    /// - Parameter responseText: The response text
    open func onComplete(_ status : Int, _ responseText : String?) throws -> Void {
    }
    /// The action method to be invoked on error
    ///
    /// - Parameter error: Error text
    open func onError(_ error : String?) throws -> Void {
    }
    /// The action method to be invoked on communicator state change
    ///
    /// - Parameter state: Current state
    open func onStateChange(_ state : Int) -> Void {
    }
}

import Foundation

/// The base class for all exceptions
open class _exception_: Error {
    internal var code: Int = 0;
    internal var message: String? = nil;
    /// Gets the exception message.
    open func getMessage() -> String? {
        return self.message;
    }
    /// Gets the exception code.
    open func getCode() -> Int {
        return self.code;
    }
    /// Creates an instance of the exception object.
    ///
    /// - Parameter code: The code of the exception
    /// - Parameter message: The exception message
    public static func create(_ code : Int, _ message : String?) -> _exception_? {
        var ex: _exception_?;
        ex = _exception_();
        ex!.code = code;
        ex!.message = message;
        return ex;
    }
}

import Foundation

/// The interface to object comparer for a sorted list
public protocol object_comparer: AnyObject {
    func compare(_ a : NSObject?, _ b : NSObject?) -> Int;
}

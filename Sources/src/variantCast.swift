import Foundation

public typealias variantCast = VariantCast

//@DocIgnore
//@Cast
public class VariantCast: NSObject {

    public static func fromInt(_ v : Int) -> variant? {
        Variant(v)
    }

    public static func fromReal(_ v : Double) -> variant? {
        Variant(v)
    }

    public static func fromDatetime(_ v : Date?) -> variant? {
        Variant(v)
    }

    public static func fromBoolean(_ v : Bool) -> variant? {
        Variant(v)
    }

    public static func fromString(_ v : String?) -> variant? {
	if v == nil {return nil}
        return Variant(v)
    }

    public static func fromObject(_ v : NSObject?) -> variant? {
	if v == nil {return nil}
        return Variant(v)
    }

    public static func castToInt(_ v : variant?) -> Int {
        (try? v?.asInt()) ?? 0
    }

    public static func castToReal(_ v : variant?) -> Double {
        (try? v?.asReal()) ?? 0
    }

    public static func castToDatetime(_ v : variant?) -> Date? {
        v?.asDatetime()
    }

    public static func castToBoolean(_ v : variant?) -> Bool {
        (try? v?.asBoolean()) ?? false
    }

    public static func castToString(_ v : variant?) -> String? {
        v?.asString()
    }

    public static func castToObject(_ v : variant?) -> NSObject? {
        v?.asObject()
    }
}

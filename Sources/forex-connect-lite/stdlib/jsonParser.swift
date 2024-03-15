import Foundation

//@DocBrief("The parser for Json")
open class jsonParser: NSObject {
    open func parse(_ json : String?) throws -> jsonNode? {
        guard let json = json else { throw _exception_.create(0, "bad json")! }
        guard let jsonData = json.data(using: .utf8) else { throw _exception_.create(0,"couldn't encode string as UTF-8")! }

        do {
            let obj = try JSONSerialization.jsonObject(with: jsonData, options: [])
            return jsonNode.fromObject(obj, nil)

        } catch {
            throw _exception_.create(0, "bad json")!
        }
    }
}

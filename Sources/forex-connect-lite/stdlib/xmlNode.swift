import Foundation

public typealias xmlNode = XmlNode

internal enum XmlNodeType: String {
    case element
    case text
    case comment
    case cdata
    case attribute

    var rawValue: String {
        switch self {
        case .element:
            return XmlNode.ELEMENT
        case .text:
            return XmlNode.TEXT
        case .comment:
            return XmlNode.COMMENT
        case .cdata:
            return XmlNode.CDATA
        case .attribute:
            return XmlNode.ATTRIBUTE
        }
    }

    init?(rawValue: String) {
        switch rawValue {
        case XmlNode.ELEMENT:
            self = .element
        case XmlNode.TEXT:
            self = .text
        case XmlNode.COMMENT:
            self = .comment
        case XmlNode.CDATA:
            self = .cdata
        case XmlNode.ATTRIBUTE:
            self = .attribute
        default:
            return nil
        }
    }

}

//@DocBrief("A node of an XML document")
public class XmlNode: NSObject {
    public static let ELEMENT: String = "element";
    public static let TEXT: String = "text";
    public static let COMMENT: String = "comment";
    public static let CDATA: String = "cdata";
    public static let ATTRIBUTE: String = "attribute";

    private var type: XmlNodeType
    private var name: String?
    private var localName: String?
    private var namespaceUri: String?
    private var value: String?

    private var children: [XmlNode] = []
    private var attributes: [String: XmlNode] = [:]

    public override init() {
        type = .text
    }

    init(
            type: XmlNodeType,
            name: String?,
            localName: String?,
            namespaceUri: String?,
            value: String?
    ) {
        self.type = type
        self.name = name
        self.localName = localName
        self.namespaceUri = namespaceUri
        self.value = value
    }

    public func getType() -> String? {
        type.rawValue
    }

    public func getName() -> String? {
        name
    }

    public func getLocalName() -> String? {
        localName
    }

    public func getNamespaceURI() -> String? {
        namespaceUri
    }

    public func getValue() -> String? {
        value
    }

    public func getChildrenCount() -> Int {
        children.count
    }

    public func getChild(_ index : Int) -> xmlNode? {
        guard index >= 0 && index < children.count else { return nil }
        return children[index]
    }

    public func getAttributesCount() -> Int {
        attributes.count
    }

    public func getAttribute(_ index : Int) -> xmlNode? {
        guard index >= 0 && index < attributes.count else { return nil }
        return Array(attributes.values)[index]
    }

    public func getAttributeByName(_ localName : String?) -> xmlNode? {
        guard let localName = localName else { return nil }
        return attributes[localName]
    }

    func add(child: XmlNode) {
        children.append(child)
    }

    func add(attribute: XmlNode, name: String) {
        attributes[name] = attribute
    }

}

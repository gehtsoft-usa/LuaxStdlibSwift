import Foundation
import SwiftyXMLParser

public typealias xmlParser = XmlParser

//@DocBrief("The parser for XML documents")
public class XmlParser: NSObject {

    public override init() {}

    public func parse(_ xml : String?) throws -> xmlNode? {
        guard let xml = xml else { throw _exception_.create(0, "bad xml")! }
        do {
            let xml = try XML.parse(xml)
            guard let root = xml.element?.childElements.first else { throw _exception_.create(0, "bad xml")! }
            return createNode(xml: root)
        } catch {
            throw _exception_.create(0, "bad xml")!
        }
    }

    private func createNode(xml: XML.Element) -> XmlNode? {
        let localName, namespaceUri: String?
        let splittedName = xml.name.split(separator: ":")
        if splittedName.count == 2 {
            localName = String(splittedName[1])
            namespaceUri = "http://\(splittedName[0])"
        } else {
            localName = nil
            namespaceUri = nil
        }
        let result = XmlNode(type: .element, name: xml.name, localName: localName, namespaceUri: namespaceUri, value: nil)

        for child in xml.childElements {
            guard let childNode = createNode(xml: child) else { continue }
            result.add(child: childNode)
        }

        if let text = xml.text {
            let textNode = XmlNode(type: .text, name: nil, localName: nil, namespaceUri: nil, value: text.trimmingCharacters(in: .whitespacesAndNewlines))
            result.add(child: textNode)
        }

        if let data = xml.CDATA {
            let value: String
            if let text = String(data: data, encoding: .utf8) {
                value = text
            } else {
                value = data.base64EncodedString()
            }
            let dataNode = XmlNode(type: .cdata, name: nil, localName: nil, namespaceUri: nil, value: value)
            result.add(child: dataNode)
        }

        for (key, value) in xml.attributes {
            let attributeNode = XmlNode(type: .attribute, name: key, localName: nil, namespaceUri: nil, value: value)
            result.add(attribute: attributeNode, name: key)
        }

        return result
    }

}

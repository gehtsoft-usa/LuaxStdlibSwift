//
//  XmlParserTest.swift
//  
//
//  Created by Nikolai Borovennikov on 23.06.2022.
//

import XCTest
import LuaxStdlib

class XmlParserTest: XCTestCase {

    let parser = XmlParser()

    func testTypes() throws {
        guard let root = try parser.parse(xmlSource) else {
            XCTFail()
            return
        }
        //printXml(root)
        XCTAssertEqual(root.getType(), XmlNode.ELEMENT)
        XCTAssertEqual(root.getChild(0)?.getType(), xmlNode.ELEMENT)
        XCTAssertEqual(root.getChild(0)?.getChild(2)?.getType(), xmlNode.CDATA)
        XCTAssertEqual(root.getChild(0)?.getChild(1)?.getType(), xmlNode.TEXT)
        XCTAssertEqual(root.getChild(0)?.getAttribute(0)?.getType(), xmlNode.ATTRIBUTE)
    }

    func testName() throws {
        guard let root = try parser.parse(xmlSource) else {
            XCTFail()
            return
        }
        //printXml(root)
        XCTAssertEqual(root.getName(), "root", "check root name")

        guard let node = root.getChild(0)?.getChild(0) else {
            XCTFail()
            return
        }
        XCTAssertEqual(node.getName(), "nsx:node11", "check node name")
        XCTAssertEqual(node.getLocalName(), "node11", "check local name")
        XCTAssertEqual(node.getNamespaceURI(), "http://nsx", "check node namespace uri")

        var attributesNames = ["attribute1", "attribute2"]
        for attributeIndex in 0..<(root.getChild(0)?.getAttributesCount() ?? 0) {
            guard let attribute = root.getChild(0)?.getAttribute(attributeIndex),
                  let name = attribute.getName() else { continue }
            attributesNames.removeAll { $0 == name }
        }
        XCTAssertEqual(attributesNames.count, 0, "check attributes names")
    }

    func testValue() throws {
        guard let root = try parser.parse(xmlSource) else {
            XCTFail()
            return
        }
        //printXml(root)

        XCTAssertEqual(root.getValue(), nil)
        XCTAssertEqual(root.getChildrenCount(), 3)
        XCTAssertEqual(root.getChild(0)?.getChildrenCount(), 3)

        var values = ["cdata is here", "and text is here"]
        for childIndex in 0..<(root.getChild(0)?.getChildrenCount() ?? 0) {
            guard let child = root.getChild(0)?.getChild(childIndex),
                  let value = child.getValue() else { continue }
            values.removeAll { $0 == value }
        }
        XCTAssertEqual(values.count, 0, "check children values")

        var attributesValues = ["value1", "value2"]
        for attributeIndex in 0..<(root.getChild(0)?.getAttributesCount() ?? 0) {
            guard let attribute = root.getChild(0)?.getAttribute(attributeIndex),
                  let value = attribute.getValue() else { continue }
            attributesValues.removeAll { $0 == value }
        }
        XCTAssertEqual(attributesValues.count, 0, "check attributes values")
    }

    func testAttributes() throws {
        guard let root = try parser.parse(xmlSource) else {
            XCTFail()
            return
        }
        //printXml(root)

        guard let node = root.getChild(0) else {
            XCTFail()
            return
        }
        XCTAssertEqual(node.getAttributesCount(), 2)

        var attributes = [
            "attribute1": "value1",
            "attribute2": "value2",
        ]
        for attributeIndex in 0..<(root.getChild(0)?.getAttributesCount() ?? 0) {
            guard let attribute = root.getChild(0)?.getAttribute(attributeIndex),
                  let name = attribute.getName(),
                  let value = attribute.getValue() else { continue }
            if attributes[name] == value {
                attributes.removeValue(forKey: name)
            }
        }
        XCTAssertEqual(attributes.count, 0, "check attributes")

        let notExistingAttribute = node.getAttributeByName("notExistent")
        XCTAssertNil(notExistingAttribute, "check not existing attribute")
    }

    func testXmlParse() throws {
        for (key, value) in xmls {
            //print("Parse «\(key)» xml")
            guard let xml = try parser.parse(value) else {
                XCTFail()
                return
            }
            //printXml(xml)
        }
    }

    // func printXml(_ xml: XmlNode, level: Int = 0) {
    //     var indent = ""
    //     for _ in 0..<level {
    //         indent += "  "
    //     }
    //     print("\(indent)### name = \(xml.getName() ?? "-"), type = \(xml.getType() ?? "-")")
    //     if let text = xml.getValue() {
    //         print("\(indent)text = «\(text.trimmingCharacters(in: .whitespacesAndNewlines))»")
    //     }
    //     for attributeNumber in 0..<xml.getAttributesCount() {
    //         guard let attribute = xml.getAttribute(attributeNumber) else { continue }
    //         print("\(indent)attribute [\(attributeNumber)] \(attribute.getName() ?? "-") = \(attribute.getValue() ?? "-")")
    //     }

    //     for childNumber in 0..<xml.getChildrenCount() {
    //         guard let child = xml.getChild(childNumber) else { continue }
    //         print("")
    //         printXml(child, level: level + 1)
    //     }
    // }

}

fileprivate let xmls = [
    "alive_response_complete": """
<?xml version="1.0" encoding="UTF-8"?>
<fxmsg v="pdas">
</fxmsg>
""",
    "alive_response_error": """
<?xml version="1.0" encoding="UTF-8"?>
<fxmsg v="pdas">
    <m t="BF" s="11" q="0">
        <f n="9102">tsqa5443</f>
        <f n="35">BF</f>
        <f n="112">U1R2_C801CDDE844F0A21E053651EA8C0D03E_11012021075527624128_GBK6X-0</f>
        <f n="336">FXCM</f>
        <f n="625">U1R2</f>
        <f n="924" t="i">0</f>
        <f n="926" t="i">3</f>
        <f n="927">Session compromised</f>
        <f n="SID">U1R2_C801CDDE844F0A21E053651EA8C0D03E_11012021075527624128_GBK6X</f>
    </m>
</fxmsg>
""",
    "hosts": """
<?xml version='1.0'?>
<hosts version="5.0">
    <host name="QA" status="active" inactive_text="Sorry1111. Temporary inactive. Will be fixed in 10 minutes or so. Please, use other connection." type="global">
        <stations>
            <station name="FXTS2" version="01.15.010101" softUpdateVersion="01.16.071621" downloadUrl="https://tsqa.gehtsoft.com:22443" updaterDescriptor="CW2\\FXCMFXTS2UpdaterDescriptor.xml"/>
            <station name="FXTS2" ib="PATRIA" version="01.15.010101" softUpdateVersion="01.15.071621" downloadUrl="https://tsqa.gehtsoft.com:22443"/>
            <station name="FXTS2" ib="TRADEBOX" version="01.15.010101" softUpdateVersion="01.15.071621" downloadUrl="https://tsqa.gehtsoft.com:22443"/>
            <station name="FXTS2" ib="HKFXCM" version="01.15.010101" softUpdateVersion="01.15.071621" downloadUrl="https://tsqa.gehtsoft.com:22443" updaterDescriptor="CW2\\HKFXTS2UpdaterDescriptor.xml"/>
            <station name="FXTS2" ib="SB" version="01.15.010101" softUpdateVersion="01.15.071621" downloadUrl="https://tsqa.gehtsoft.com:22443" updaterDescriptor="CW2\\SBFXTS2UpdaterDescriptor.xml"/>
        </stations>
        <urls>
            <url name="pdas" urlString="pdas:http://tsqa.gehtsoft.com:5433" protocol="http" secure="true" params="communication-channels=2;polling-interval=0;sticking-time=3000;http-header-encoding=Accept-Encoding: deflate;"/>
        </urls>
    </host>
    <host name="U1R2" status="active" inactive_text="Sorry2222. Temporary inactive. Will be fixed in 10 minutes or so. Please, use other connection." id="FXCM" subid="U1R2" description="USD Mini Account (F1)" type="trading" price_terminal="PRICES_QA" S="bHpXc2RXVkpIQnNGTmpCUkx0bGl2SmVBY293WHdP">
        <stations>
            <station name="FXTS2" version="01.15.010101" softUpdateVersion="01.16.070417" downloadUrl="https://tsqa.gehtsoft.com:22443" updaterDescriptor="CW2\\FXCMFXTS2UpdaterDescriptor.xml"/>
        </stations>
        <urls>
            <url name="pdas" urlString="pdas:http://tsqa.gehtsoft.com:5443" protocol="http" secure="true" params="communication-channels=2;polling-interval=0;sticking-time=3000;http-header-encoding=Accept-Encoding: deflate;"/>
        </urls>
    </host>
    <host name="J100R1" status="active" inactive_text="Sorry. Temporary inactive. Will be fixed in 10 minutes or so. Please, use other connection." id="FXCM" subid="J100R1" description="JPY 100K Account (F1)" type="trading" price_terminal="PRICES_QA" chart_terminal="CHART" S="bHpXc2RXVkpIQnNGTmpCUkx0bGl2SmVBY293WHdP">
        <stations>
            <station name="FXTS2" version="01.15.010101" softUpdateVersion="01.16.070417" downloadUrl="https://tsqa.gehtsoft.com:22443" updaterDescriptor="CW2\\FXCMFXTS2UpdaterDescriptor.xml"/>
        </stations>
        <urls>
            <url name="pdas" urlString="pdas:http://tsqa.gehtsoft.com:5443" protocol="http" secure="true" params="communication-channels=2;polling-interval=0;sticking-time=3000;http-header-encoding=Accept-Encoding: deflate;"/>
        </urls>
    </host>
    <host name="PRICES_QA" status="active" inactive_text="Currently not aviable," type="price">
        <urls>
            <url name="pdas" urlString="pdas:http://tsqa.gehtsoft.com:5081" protocol="http" secure="true" params="http-servlet-path=/servlet/pdas;communication-channels=2;polling-interval=500;sticking-time=3000;client-conection-factory=192.168.23.4"/>
        </urls>
    </host>
    <host name="CHART" status="active" inactive_text="Currently not aviable, please use DAS...." type="chart">
        <stations>
            <station name="FXDS2" version="01.13.122114" downloadUrl="https://tsqa.gehtsoft.com:22443" updaterDescriptor="CW\\DS2UpdaterDescriptor.xml"/>
            <station name="FXTS2" version="01.15.010101" softUpdateVersion="01.16.070417" downloadUrl="https://tsqa.gehtsoft.com:22443" updaterDescriptor="CW2\\FXCMFXTS2UpdaterDescriptor.xml"/>
        </stations>
        <urls>
            <url name="pdas" urlString="pdas:http://tsqa.gehtsoft.com:5082" protocol="http" secure="true" params="http-servlet-path=/servlet/pdas;communication-channels=2;polling-interval=500;sticking-time=3000;client-connection-factory=192.168.23.4"/>
        </urls>
    </host>
</hosts>
""",
    "hosts_Demo": """
<?xml version='1.0'?>
<hosts version="5.0">
    <host name="Demo" status="active" inactive_text="Currently not aviable, please use DAS...." type="global">
        <stations/>
        <urls>
            <url name="pdas" urlString="pdas:http://pdemo41.fxcorporate.com" protocol="http" secure="false" params="http-servlet-path=/pdas/servlet;client-connection-factory=77.221.218.10;communication-channels=2;polling-interval=500;sticking-time=3000"/>
        </urls>
    </host>
    <host name="GBDEMO" status="active" inactive_text="Currently not aviable, please use DAS...." id="FXCM" subid="GBDEMO" description="GBP Mini Demo" type="trading" price_terminal="PDEMO_PRICES" S="aVNBblJEaEhBRnNNSmxrZUVBU3lmRkJWTmtqSWJJ">
        <urls>
            <url name="pdas" urlString="pdas:http://pdemo.fxcorporate.com" protocol="http" secure="true" params="http-servlet-path=/pdas/servlet;client-connection-factory=77.221.218.10;communication-channels=2;polling-interval=0;sticking-time=3000"/>
        </urls>
    </host>
    <host name="PDEMO_PRICES" status="active" inactive_text="Currently not aviable, please use DAS...." type="price">
        <urls>
            <url name="pdas" urlString="pdas:http://bbo3.fxcorporate.com" protocol="http" secure="true" params="http-servlet-path=/pdas/servlet;client-connection-factory=77.221.218.10;communication-channels=1;polling-interval=500;sticking-time=3000"/>
        </urls>
    </host>
</hosts>
""",
    "log4j2": """
<Configuration>
    <Appenders>
        <Console name="STDOUT">
            <PatternLayout pattern="%d %-5level [%logger] %msg%n%xThrowable" />
        </Console>
    </Appenders>
    <Loggers>
        <Logger name="org.apache.hc.client5.http" level="DEBUG"/>
        <Logger name="org.apache.hc.client5.http.wire" level="DEBUG"/>
        <Root level="DEBUG">
            <AppenderRef ref="STDOUT" />
        </Root>
    </Loggers>
</Configuration>
""",
    "login_check_status_response_complete": """
<?xml version="1.0" encoding="UTF-8"?>
<fxmsg v="pdas">
    <m t="BF" s="13" q="0">
        <f n="926" t="i">1</f>
        <f n="927">0
GBDEMO_B99819479B179133E053E12B3C0A642B_10292021063122657229_98S;20;864144;
        </f>
    </m>
</fxmsg>
""",
    "login_check_status_response_error": """
<?xml version="1.0" encoding="UTF-8"?>
<fxmsg v="pdas">
    <m t="BF" s="13" q="0">
        <f n="926" t="i">2</f>
        <f n="927">Timed out</f>
    </m>
</fxmsg>
""",
    "login_check_status_response_not_complete": """
<?xml version="1.0" encoding="UTF-8"?>
<fxmsg v="pdas">
    <m t="BF" s="13" q="0">
        <f n="926" t="i">0</f>
        <f n="927">0
1635489082650-297404;</f>
    </m>
</fxmsg>
""",
    "login_request": """
<?xml version="1.0" encoding="UTF-8"?>
<fxmsg v="pdas">
    <m t="BE" s="10" q="0">
        <f n="112">NewSession-587658375-19866-14904</f>
        <f n="336">FXCM</f>
        <f n="35">BE</f>
        <f n="553">D25864144</f>
        <f n="554">ysbHoD5Sx1EczsiM2rVhDuHInEQ=</f>
        <f n="625">GBDEMO</f>
        <l n="9016" s="8">
            <g s="2">
                <f n="9017">aClientTransport</f>
                <f n="9018">C01.18.1702.1314</f>
            </g>
            <g s="2">
                <f n="9017">aRemoteAddress</f>
                <f n="9018">77.221.218.10;</f>
            </g>
            <g s="2">
                <f n="9017">aRemoteAppName</f>
                <f n="9018">ForexConnect</f>
            </g>
            <g s="2">
                <f n="9017">aRemoteAppCode</f>
                <f n="9018">Login</f>
            </g>
            <g s="2">
                <f n="9017">MessageFlags</f>
                <f n="9018" t="l">0</f>
            </g>
            <g s="2">
                <f n="9017">EXTRA</f>
                <f n="9018">3,139,9,5,138</f>
            </g>
            <g s="2">
                <f n="9017">TokenKeyRequired</f>
                <f n="9018">true</f>
            </g>
            <g s="2">
                <f n="9017">asynch</f>
                <f n="9018">yes</f>
            </g>
        </l>
        <f n="923">NewSession-587658375-19866-14904</f>
        <f n="924" t="i">1</f>
        <f n="SID"/>
    </m>
</fxmsg>
""",
    "login_response": """
<?xml version="1.0" encoding="UTF-8"?>
<fxmsg v="pdas">
    <m t="BF" s="9" q="0">
        <f n="9102">pdemo443</f>
        <f n="35">BF</f>
        <f n="112">NewSession-1635422553839-131220-1</f>
        <f n="923">NewSession-1635422553839-131220-1</f>
        <f n="924" t="i">0</f>
        <f n="926" t="i">3</f>
        <f n="927">0
1635422553839-12233212123-1;</f>
    </m>
</fxmsg>
""",
]

fileprivate let xmlSource = "<?xml version='1.0'?><root xmlns:nsx='http://nsx'>\n<node1 attribute1='value1' attribute2='value2'>\n\n\t\t<!--comment--><![CDATA[cdata is here]]>and text is here<nsx:node11/>\n</node1>\r\n<node2 attribute3='value3'/></root>"

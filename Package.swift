// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ForexConnectLite",
    platforms: [
            .macOS(.v10_15),
            .iOS(.v12),
    ],  
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "ForexConnectLite",
            targets: ["ForexConnectLite"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/yahoojapan/SwiftyXMLParser", from: "5.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "ForexConnectLite",
            dependencies: [
                "SwiftyXMLParser",
                "DataDeflate",
            ],
            path: "Sources/forex-connect-lite"),
        .target(
            name: "DataDeflate",
            path: "Sources/ObjC/DataDeflate"
        ),
        .testTarget(
            name: "stdlibTests",
            dependencies: ["ForexConnectLite"],
            path: "Sources/Tests/stdLibTests",
            resources: [
                .process("get_all_instruments(139)(USD_Base).csv")
            ]),
    ]
)

// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "onewaypath.com",
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "3.3.0"),
        // 🍃 An expressive, performant, and extensible templating language built for Swift.
        .package(url: "https://github.com/vapor/leaf.git", from: "3.0.2"),
        .package(url: "git@github.com:onewaypath/UnixIntegrationTools.git", .exact("1.1.2")),
        .package(url: "https://github.com/vapor/fluent-mysql.git", from: "3.0.0-rc"),
        .package(url: "https://github.com/vapor/mysql.git", from: "3.0.0")
       
    ],
    targets: [
      
        .target(name: "App", dependencies: ["Leaf", "Vapor", "unixTools", "FluentMySQL", "MySQL"]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"]),
       
    ]
)


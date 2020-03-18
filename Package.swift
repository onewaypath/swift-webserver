// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "onewaypath.com",
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "3.3.0"),
        // 🍃 An expressive, performant, and extensible templating language built for Swift.
        .package(url: "https://github.com/vapor/leaf.git", from: "3.0.2"),
        //.package(url: "https://github.com/rahyoung/unixTools.git", from: "1.0.2")
        //.package(url: "git@github.com:rahyoung/apiTools.git", from: "1.0.1")
        //.package(url: "../apiTools/.git", from: "1.0.1")
        //.package(url: "https://github.com/rahyoung/apiTools.git",  from: "1.0.0")

    ],
    targets: [
      /*  .target(name: "activeCampaignApi", dependencies: ["Vapor"], path: "activeCampaignApi"),
        .target(name: "App", dependencies: ["Leaf", "Vapor", "activeCampaignApi"]),*/
        .target(name: "App", dependencies: ["Leaf", "Vapor"]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"]),
        /*
        .testTarget(name: "activeCampaignApiTests", dependencies: ["activeCampaignApi"], path: "activeCampaignApiTests")
        */
    ]
)


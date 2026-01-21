// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-iprompt-service",
    platforms: [
        .macOS("13.0"),
        .iOS("18.0"),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "iPromptService",
            targets: ["iPromptService"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.11.0")),
        .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", from: "1.9.0"),
        .package(url: "https://github.com/kishikawakatsumi/KeychainAccess.git", from: "4.2.2"),
        .package(url: "https://github.com/Tencent/wcdb.git", from: "2.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "iPromptService",
            dependencies: [
                .product(name: "Alamofire", package: "Alamofire"),
                .product(name: "CryptoSwift", package: "CryptoSwift"),
                .product(name: "KeychainAccess", package: "KeychainAccess"),
                .product(name: "WCDBSwift", package: "wcdb"),
            ]
        ),
        .testTarget(
            name: "iPromptServiceTests",
            dependencies: ["iPromptService"]
        ),
    ]
)

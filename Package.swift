// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BitcoinSwift",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "BitcoinSwift",
            targets: ["BitcoinSwift"]),
    ],
    dependencies: [
        .package(url: "git@github.com:joseamena/BigInt.git", branch: "master"),
        .package(url: "https://github.com/anquii/RIPEMD160", branch: "main"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "BitcoinSwift",
            dependencies: [
                .product(name: "BigInt", package: "BigInt"),
                .product(name: "RIPEMD160", package: "RIPEMD160")
            ]
        ),
        .testTarget(
            name: "BitcoinSwiftTests",
            dependencies: ["BitcoinSwift"]),
    ]
)

// swift-tools-version: 6.2
import PackageDescription

let mode: [SwiftSetting] = [.swiftLanguageMode(.v5)]
let package = Package(
    name: "CapcapKit", defaultLocalization: "en", platforms: [.macOS(.v15)],
    products: [
        .library(name: "CapcapKit", type: .static, targets: ["CapcapKit"]),
        .library(name: "CapcapText", targets: ["CapcapText"]),
        .library(name: "CapcapRecording", targets: ["CapcapRecording"]),
        .library(name: "CapcapUpload", targets: ["CapcapUpload"]),
        .library(name: "CapcapPinning", targets: ["CapcapPinning"]),
        .library(name: "CapcapHistory", targets: ["CapcapHistory"]),
        .library(name: "CapcapImageMerge", targets: ["CapcapImageMerge"]),
    ],
    targets: [
        .target(name: "CapcapSupport", resources: [.process("Resources")], swiftSettings: mode),
        .target(name: "CapcapKit", dependencies: ["CapcapSupport"], swiftSettings: mode,
                linkerSettings: [.linkedFramework("Carbon"), .linkedLibrary("z")]),
        .target(name: "CapcapText", dependencies: ["CapcapSupport"], swiftSettings: mode),
        .target(name: "CapcapRecording", dependencies: ["CapcapSupport"], swiftSettings: mode),
        .target(name: "CapcapUpload", dependencies: ["CapcapSupport", "CapcapKit"], swiftSettings: mode),
        .target(name: "CapcapPinning", dependencies: ["CapcapSupport", "CapcapKit", "CapcapText"], swiftSettings: mode),
        .target(name: "CapcapHistory", dependencies: ["CapcapSupport", "CapcapKit", "CapcapText"], swiftSettings: mode),
        .target(name: "CapcapImageMerge", dependencies: ["CapcapSupport", "CapcapKit"], swiftSettings: mode),
        .testTarget(name: "CapcapKitTests", dependencies: ["CapcapSupport", "CapcapKit", "CapcapText"], swiftSettings: mode),
        .testTarget(name: "CapcapOptionalTests", dependencies: ["CapcapSupport", "CapcapText", "CapcapUpload", "CapcapPinning"]),
    ]
)

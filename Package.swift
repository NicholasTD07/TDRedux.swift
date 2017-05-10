import PackageDescription

let package = Package(
    name: "TDRedux",
    dependencies: [
        .Package(url: "https://github.com/NicholasTD07/spec.swift.git", majorVersion: 1),
    ],
    exclude: [
        "Carthage",
    ]
)

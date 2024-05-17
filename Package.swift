// swift-tools-version: 5.8

import PackageDescription

let package = Package(
  name: "TCARouteStack",
  platforms: [
    .iOS(.v16)
  ],
  products: [
    .library(
      name: "TCARouteStack",
      targets: ["TCARouteStack"]),
  ],
  dependencies: [
    .package(url: "https://github.com/Monsteel/RouteStack.git", .upToNextMinor(from: "0.1.2")),
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", "1.0.0" ..< "1.7.0"),
  ],
  targets: [
    .target(
      name: "TCARouteStack",
      dependencies: [
        .product(name: "RouteStack", package: "RouteStack"),
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
      ]
    ),
  ]
)

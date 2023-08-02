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
    .package(url: "https://github.com/Monsteel/RouteStack.git", from: "0.0.7"),
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "0.56.0"),
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

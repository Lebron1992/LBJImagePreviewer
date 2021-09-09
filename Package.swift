// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "LBJImagePreviewer",
  platforms: [.iOS(.v15)],
  products: [
    .library(
      name: "LBJImagePreviewer",
      targets: ["LBJImagePreviewer"]),
  ],
  targets: [
    .target(
      name: "LBJImagePreviewer",
      resources: [.process("PreviewContent")]
    ),
    .testTarget(
      name: "LBJImagePreviewerTests",
      dependencies: ["LBJImagePreviewer"]
    )
  ]
)

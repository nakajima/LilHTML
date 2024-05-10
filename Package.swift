// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import Foundation
import PackageDescription

let package = Package(
	name: "LilHTML",
	platforms: [.macOS(.v14), .iOS(.v17)],
	products: [
		// Products define the executables and libraries a package produces, making them visible to other packages.
		.library(
			name: "LilHTML",
			targets: ["LilHTML"]
		),
	],
	targets: [
		.target(
			name: "LilHTML",
			swiftSettings: [
				.enableUpcomingFeature("StrictConcurrency"),
				.enableUpcomingFeature("ExistentialAny"),
				.unsafeFlags([
					"-enable-bare-slash-regex",
				]),
			]
		),
		.testTarget(
			name: "LilParserTests",
			dependencies: ["LilHTML"],
			resources: [
				.process("Resources/basic.html"),
			]
		),
	]
)

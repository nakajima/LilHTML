// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import Foundation
import PackageDescription

let package = Package(
	name: "LilParser",
	platforms: [.macOS(.v14), .iOS(.v17)],
	products: [
		// Products define the executables and libraries a package produces, making them visible to other packages.
		.library(
			name: "LilParser",
			targets: ["LilParser"]
		),
	],
	dependencies: [
		.package(url: "https://github.com/nakajima/LilTidy.swift", branch: "main"),
	],
	targets: [
		.target(
			name: "LilParser",
			dependencies: [
				.product(name: "LilTidy", package: "LilTidy.swift"),
			],
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
			dependencies: ["LilParser"],
			resources: [
				.process("Resources/basic.html"),
				.process("Resources/list.html"),
			]
		),
	]
)
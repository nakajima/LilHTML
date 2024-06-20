// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import Foundation
import PackageDescription

#if os(Linux)
let dependencies: [Target.Dependency] = ["libxml2"]
let pkgConfig = "libxml-2.0"
let provider: [SystemPackageProvider] = [
		.apt(["libxml2-dev"])
]
#else
let dependencies: [Target.Dependency] = []
let pkgConfig: String? = nil
let provider: [SystemPackageProvider] = []
#endif

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
		.systemLibrary(
			name: "libxml2",
			pkgConfig: pkgConfig,
			providers: provider
		),
		.target(
			name: "LilHTML",
			dependencies: dependencies,
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
				.process("Resources/musicradar.html"),
			]
		),
	]
)

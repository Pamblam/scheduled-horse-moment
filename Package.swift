// swift-tools-version: 5.9
import PackageDescription

let package = Package(
	name: "BackgroundApp",
	platforms: [
		.macOS(.v13)
	],
	products: [
		.executable(name: "BackgroundApp", targets: ["BackgroundApp"])
	],
	targets: [
		   .executableTarget(
			   name: "BackgroundApp",
			   resources: [
				   .process("Resources")
			   ]
		   )
	]
)

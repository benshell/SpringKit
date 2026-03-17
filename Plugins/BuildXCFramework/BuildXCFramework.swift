import PackagePlugin
import Foundation

/// Swift Package command plugin that builds SpringKit.xcframework.
///
/// Run from the command line:
///   swift package plugin build-xcframework
///   swift package plugin build-xcframework --target zip
///   swift package plugin build-xcframework --target binary-package
///
/// Run from Xcode:
///   Right-click SpringKit package → SpringKit Plugins → Build XCFramework
@main
struct BuildXCFramework: CommandPlugin {

    func performCommand(context: PluginContext, arguments: [String]) throws {
        var extractor = ArgumentExtractor(arguments)
        let targets = extractor.extractOption(named: "target")
        let target = targets.first ?? "xcframework"

        let packageURL = context.package.directoryURL

        let workspaceURL = packageURL.appending(path: ".swiftpm/xcode/package.xcworkspace")
        guard FileManager.default.fileExists(atPath: workspaceURL.path) else {
            print("""
            ✗ Xcode workspace not found at .swiftpm/xcode/package.xcworkspace
              Open Package.swift in Xcode at least once to generate it, then retry.
            """)
            throw PluginError.workspaceMissing
        }

        let makefileURL = packageURL.appending(path: "Makefile")
        guard FileManager.default.fileExists(atPath: makefileURL.path) else {
            print("✗ Makefile not found in package directory.")
            throw PluginError.makefileMissing
        }

        print("▸ SpringKit: running 'make \(target)'…")

        let make = Process()
        make.executableURL = URL(fileURLWithPath: "/usr/bin/make")
        make.arguments = [target]
        make.currentDirectoryURL = packageURL
        try make.run()
        make.waitUntilExit()

        guard make.terminationStatus == 0 else {
            throw PluginError.makeFailed(target: target, exitCode: make.terminationStatus)
        }

        print("✓ SpringKit: '\(target)' succeeded.")
    }

    enum PluginError: Error, CustomStringConvertible {
        case workspaceMissing
        case makefileMissing
        case makeFailed(target: String, exitCode: Int32)

        var description: String {
            switch self {
            case .workspaceMissing:
                return "Xcode workspace not found — open Package.swift in Xcode first."
            case .makefileMissing:
                return "Makefile not found in package directory."
            case .makeFailed(let target, let code):
                return "make \(target) exited with code \(code)."
            }
        }
    }
}

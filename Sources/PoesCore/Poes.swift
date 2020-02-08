//
//  Poes.swift
//  PoesCore
//
//  Created by Antoine van der Lee on 07/02/2020.
//  Copyright © 2020 AvdLee. All rights reserved.
//

import Foundation
import SPMUtility

public struct Poes: ShellInjectable {
    enum Error: Swift.Error, CustomStringConvertible {
        case missingBundleIdentifier

        var description: String {
            switch self {
            case .missingBundleIdentifier:
                return "Pass in the bundle identifier with the --bundle-identifier argument"
            }
        }
    }

    static var usage: String = "<options>"
    static var overview: String = "A Swift command-line tool to easily send push notifications to the iOS simulator"

    public static func run(arguments: [String] = ProcessInfo.processInfo.arguments) throws {
        Log.isVerbose = arguments.contains("--verbose")
        let parser = ArgumentParser(usage: usage, overview: overview)
        _ = parser.add(option: "--verbose", kind: Bool.self, usage: "Show extra logging for debugging purposes")

        let bundleIdentifierArgument = parser.add(option: "--bundle-identifier", kind: String.self, usage: "The bundle identifier to push to")
        let titleArgument = parser.add(option: "--title", shortName: "-t", kind: String.self, usage: "The title of the Push Notification")
        let bodyArgument = parser.add(option: "--body", shortName: "-b", kind: String.self, usage: "The body of the Push Notification")
        let isMutableArgument = parser.add(option: "--mutable", shortName: "-m", kind: Bool.self, usage: "Adds the mutable-content key to the payload")


        let parsedArguments = try parser.process(arguments: arguments)

        guard let bundleIdentifier = parsedArguments.get(bundleIdentifierArgument) else {
            throw Error.missingBundleIdentifier
        }

        let title = parsedArguments.get(titleArgument) ?? "Default title"
        let body = parsedArguments.get(bodyArgument) ?? "Default body"
        let isMutable = parsedArguments.get(isMutableArgument) ?? false

        let payload = Payload(title: title, body: body, isMutable: isMutable)
        let jsonData = try JSONEncoder().encode(payload)

        if Log.isVerbose, let object = try? JSONSerialization.jsonObject(with: jsonData, options: []), let jsonString = String(data: try! JSONSerialization.data(withJSONObject: object, options: .prettyPrinted), encoding: .utf8) {
            Log.debug("Generated payload:\n\n\(jsonString)\n")
        }

        let url = Foundation.URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true).appendingPathComponent("payload.json")
        FileManager.default.createFile(atPath: url.path, contents: jsonData, attributes: nil)

        Log.message("Sending push notification...")
        shell.execute(.push(bundleIdentifier: bundleIdentifier, payloadPath: url.path))
        Log.message("Push notification sent successfully")
    }
}

private extension ArgumentParser {
    @discardableResult func process(arguments: [String]) throws -> ArgumentParser.Result {
        // We drop the first argument as this is always the execution path. In our case: "gitbuddy"
        return try parse(Array(arguments.dropFirst()))
    }
}


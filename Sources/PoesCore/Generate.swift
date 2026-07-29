//
//  Generate.swift
//  PoesCore
//
//  Created by Poes.
//

import Foundation
import ArgumentParser

struct Generate: ParsableCommand {

    static let configuration = CommandConfiguration(
        abstract: "Generate an .apns payload file that can be dragged into the iOS Simulator"
    )

    @Argument(help: "The bundle identifier of the app to target")
    private var bundleIdentifier: String

    @Option(name: .shortAndLong, default: "Default Title", help: "The title of the Push notification")
    private var title: String

    @Option(name: .shortAndLong, default: "Default Body", help: "The body of the Push notification")
    private var body: String

    @Option(name: .shortAndLong, help: "The number to display in a badge on your app's icon")
    private var badge: Int?

    @Flag(name: .shortAndLong, help: "Adds the mutable-content key to the payload")
    private var isMutable: Bool

    @Option(name: .shortAndLong, default: "payload.apns", help: "The output file path (must end with .apns)")
    private var output: String

    @Flag(name: .long, help: "Show extra logging for debugging purposes")
    private var verbose: Bool

    func run() throws {
        Log.isVerbose = verbose

        let apnsFile = APNSFile(
            simulatorTargetBundle: bundleIdentifier,
            aps: APS(alert: Alert(title: title, body: body), isMutable: isMutable, badge: badge)
        )

        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let jsonData = try encoder.encode(apnsFile)

        let outputURL = URL(fileURLWithPath: output)

        guard outputURL.pathExtension == "apns" else {
            throw ValidationError("Output file must have .apns extension")
        }

        try jsonData.write(to: outputURL, options: .atomic)

        if Log.isVerbose {
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                Log.debug("Generated APNS file:\n\n\(jsonString)\n")
            }
        }

        Log.message("APNS file generated successfully at: \(outputURL.path)")
    }
}

/// The structure of an .apns file that can be dragged into the iOS Simulator.
struct APNSFile: Codable {
    enum CodingKeys: String, CodingKey {
        case simulatorTargetBundle = "Simulator Target Bundle"
        case aps
    }

    let simulatorTargetBundle: String
    let aps: APS
}
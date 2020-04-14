//
//  Send.swift
//  PoesCore
//
//  Created by Antoine van der Lee on 08/02/2020.
//  Copyright © 2020 AvdLee. All rights reserved.
//

import Foundation
import ArgumentParser

struct Send: ParsableCommand, ShellInjectable {

    public static let configuration = CommandConfiguration(abstract: "Send a push notification to an app installed on the iOS Simulator")

    @Argument(help: "The bundle identifier of the app to push to")
    private var bundleIdentifier: String

    @Option(name: .shortAndLong, default: "Default Title", help: "The title of the Push notification")
    private var title: String

    @Option(name: .shortAndLong, default: "Default Body", help: "The body of the Push notification")
    private var body: String

    @Option(name: .shortAndLong, help: "The number to display in a badge on your app’s icon")
    private var badge: Int?
    
    @Flag(name: .shortAndLong, help: "Adds the mutable-content key to the payload")
    private var isMutable: Bool

    @Flag(name: .long, help: "Show extra logging for debugging purposes")
    private var verbose: Bool

    func run() throws {
        Log.isVerbose = verbose

        let payload = Payload(title: title, body: body, isMutable: isMutable, badge: badge)
        let jsonData = try JSONEncoder().encode(payload)

        if Log.isVerbose, let object = try? JSONSerialization.jsonObject(with: jsonData, options: []), let jsonString = String(data: try! JSONSerialization.data(withJSONObject: object, options: .prettyPrinted), encoding: .utf8) {
            Log.debug("Generated payload:\n\n\(jsonString)\n")
        }

        let tempUrl = NSTemporaryDirectory()
        let payloadUrl = Foundation.URL(fileURLWithPath: tempUrl, isDirectory: true).appendingPathComponent("payload.json")
        FileManager.default.createFile(atPath: payloadUrl.path, contents: jsonData, attributes: nil)

        Log.message("Sending push notification...")
        Self.shell.execute(.push(bundleIdentifier: bundleIdentifier, payloadPath: payloadUrl.path))
        Log.message("Push notification sent successfully")
        try FileManager.default.removeItem(at: payloadUrl)
    }
}

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

    @Argument(help: "The bundle identifier of the app to push to")
    private var bundleIdentifier: String

    @Option(default: "Default Title", help: "The title of the Push notification")
    private var title: String

    @Option(default: "Default Body", help: "The body of the Push notification")
    private var body: String

    @Option(default: false, help: "Adds the mutable-content key to the payload")
    private var isMutable: Bool

    func run() throws {
        let payload = Payload(title: title, body: body, isMutable: isMutable)
        let jsonData = try JSONEncoder().encode(payload)

        if Log.isVerbose, let object = try? JSONSerialization.jsonObject(with: jsonData, options: []), let jsonString = String(data: try! JSONSerialization.data(withJSONObject: object, options: .prettyPrinted), encoding: .utf8) {
            Log.debug("Generated payload:\n\n\(jsonString)\n")
        }

        let url = Foundation.URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true).appendingPathComponent("payload.json")
        FileManager.default.createFile(atPath: url.path, contents: jsonData, attributes: nil)

        Log.message("Sending push notification...")
        Self.shell.execute(.push(bundleIdentifier: bundleIdentifier, payloadPath: url.path))
        Log.message("Push notification sent successfully")
    }
}

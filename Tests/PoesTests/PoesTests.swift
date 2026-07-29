//
//  PoesTests.swift
//  PoesTests
//
//  Created by Antoine van der Lee on 07/02/2020.
//  Copyright © 2020 AvdLee. All rights reserved.
//

import XCTest
@testable import PoesCore

final class PoesTests: XCTestCase {

    override class func setUp() {
        super.setUp()

        ShellInjector.shell = MockedShell.self
    }

    /// It should correctly generate a JSON payload for sending push notifications.
    func testSendCommand() throws {
        let expectedBundleIdentifier = "com.example.app"
        let title = "Notification title"
        let body = "Notification body"
        let badge = 2
        let isMutable = true

        let arguments = ["send", expectedBundleIdentifier, "--title", title, "--body", body, "--badge", "\(badge)", "--is-mutable"]

        let poesCommand = try Poes.parseAsRoot(arguments)
        try poesCommand.run()

        let command = try XCTUnwrap(MockedShell.executedCommand)

        guard case let ShellCommand.push(bundleIdentifier, payloadPath) = command else {
            XCTFail("Command is not executed")
            return
        }

        XCTAssertEqual(expectedBundleIdentifier, bundleIdentifier)

        let jsonData = try Data(contentsOf: URL(fileURLWithPath: payloadPath))
        let payload = try JSONDecoder().decode(Payload.self, from: jsonData)

        XCTAssertEqual(payload.aps.alert.title, title)
        XCTAssertEqual(payload.aps.alert.body, body)
        XCTAssertEqual(payload.aps.isMutable, isMutable)
        XCTAssertEqual(payload.aps.badge, badge)

    }

    /// It should generate an .apns file with the correct structure.
    func testGenerateCommand() throws {
        let bundleIdentifier = "com.example.app"
         let title = "Generated title"
        let body = "Generated body"
 let badge = 5
         let outputPath = NSTemporaryDirectory() + "test_payload.apns"

        defer {
            try? FileManager.default.removeItem(atPath: outputPath)
        }

        let arguments = [
            "generate", bundleIdentifier,
            "--title", title,
            "--body", body,
            "--badge", "\(badge)",
            "--is-mutable",
            "--output", outputPath
        ]

        let poesCommand = try Poes.parseAsRoot(arguments)
        try poesCommand.run()

        let jsonData = try Data(contentsOf: URL(fileURLWithPath: outputPath))
        let apnsFile = try JSONDecoder().decode(APNSFile.self, from: jsonData)
        XCTAssertEqual(apnsFile.simulatorTargetBundle, bundleIdentifier)
        XCTAssertEqual(apnsFile.aps.alert.title, title)
        XCTAssertEqual(apnsFile.aps.alert.body, body)
        XCTAssertEqual(apnsFile.aps.badge, badge)
        XCTAssertTrue(apnsFile.aps.isMutable)
    }

    /// It should reject output files without .apns extension.
    func testGenerateCommandRejectsInvalidExtension() throws {
        let arguments = [
            "generate", "com.example.app",
            "--output", "payload.json"
        ]

        let poesCommand = try Poes.parseAsRoot(arguments)
        XCTAssertThrowsError(try poesCommand.run())
    }
}

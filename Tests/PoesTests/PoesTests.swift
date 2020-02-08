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

    /// It should correctly generate a JSON payload.
    func testPayloadGeneration() throws {
        let expectedBundleIdentifier = "com.example.app"
        let title = "Notification title"
        let body = "Notification body"
        let isMutable = true
        try Poes.run(arguments: ["poes", "--bundle-identifier", expectedBundleIdentifier, "-t", title, "-b", body, "-m"])

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

    }
}

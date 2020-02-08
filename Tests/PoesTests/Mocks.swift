//
//  Mocks.swift
//  PoesTests
//
//  Created by Antoine van der Lee on 08/02/2020.
//  Copyright © 2020 AvdLee. All rights reserved.
//

import Foundation
@testable import PoesCore

struct MockedShell: ShellExecuting {

    static var commandMocks: [String: String] = [:]
    static private(set) var executedCommand: ShellCommand?

    @discardableResult static func execute(_ command: ShellCommand) -> String {
        executedCommand = command
        return commandMocks[command.rawValue] ?? ""
    }

    static func mock(_ command: ShellCommand, value: String) {
        commandMocks[command.rawValue] = value
    }
}

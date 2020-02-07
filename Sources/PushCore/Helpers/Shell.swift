//
//  Shell.swift
//  GitBuddyCore
//
//  Created by Antoine van der Lee on 10/01/2020.
//  Copyright © 2020 AvdLee. All rights reserved.
//

import Foundation

enum ShellCommand {
    case push(bundleIdentifier: String, payloadPath: String)

    var rawValue: String {
        switch self {
        case .push(let bundleIdentifier, let payloadPath):
            return "xcrun simctl push booted \(bundleIdentifier) \(payloadPath)"
        }
    }
}

extension Process {
    func shell(_ command: ShellCommand) -> String {
        launchPath = "/bin/bash"
        arguments = ["-c", command.rawValue]

        let outputPipe = Pipe()
        standardOutput = outputPipe
        launch()

        let data = outputPipe.fileHandleForReading.readDataToEndOfFile()
        guard let outputData = String(data: data, encoding: String.Encoding.utf8) else { return "" }

        return outputData.reduce("") { (result, value) in
            return result + String(value)
        }.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

protocol ShellExecuting {
    @discardableResult static func execute(_ command: ShellCommand) -> String
}

private enum Shell: ShellExecuting {
    @discardableResult static func execute(_ command: ShellCommand) -> String {
        return Process().shell(command)
    }
}

/// Adds a `shell` property which defaults to `Shell.self`.
protocol ShellInjectable { }

extension ShellInjectable {
    static var shell: ShellExecuting.Type { ShellInjector.shell }
}

enum ShellInjector {
    static var shell: ShellExecuting.Type = Shell.self
}

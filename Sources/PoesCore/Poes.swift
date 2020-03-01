//
//  Poes.swift
//  PoesCore
//
//  Created by Antoine van der Lee on 07/02/2020.
//  Copyright © 2020 AvdLee. All rights reserved.
//

import Foundation
import ArgumentParser

public struct Poes: ParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "Poes",
        abstract: "A Swift command-line tool to easily test push notifications to the iOS simulator",
        subcommands: [Send.self])

    public init() { }
}

//
//  Log.swift
//  GitBuddyCore
//
//  Created by Antoine van der Lee on 10/01/2020.
//  Copyright © 2020 AvdLee. All rights reserved.
//

import Foundation

enum Log {
    static var isVerbose: Bool = false

    static func debug(_ message: Any) {
        guard isVerbose else { return }
        print(message)
    }

    static func message(_ message: Any) {
        print(message)
    }
}

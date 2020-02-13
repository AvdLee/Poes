//
//  PayloadFactory.swift
//  PoesCore
//
//  Created by Antoine van der Lee on 08/02/2020.
//  Copyright © 2020 AvdLee. All rights reserved.
//

import Foundation
import SPMUtility

struct PayloadFactory {
    private let titleArgument: OptionArgument<String>
    private let bodyArgument: OptionArgument<String>
    private let isMutableArgument: OptionArgument<Bool>
    private let badgeArgument: OptionArgument<Int>

    init(parser: ArgumentParser) {
        titleArgument = parser.add(option: "--title", shortName: "-t", kind: String.self, usage: "The title of the Push Notification")
        bodyArgument = parser.add(option: "--body", shortName: "-b", kind: String.self, usage: "The body of the Push Notification")
        isMutableArgument = parser.add(option: "--mutable", shortName: "-m", kind: Bool.self, usage: "Adds the mutable-content key to the payload")
        badgeArgument = parser.add(option: "--badge", kind: Int.self, usage: "The number to display in a badge on your app’s icon")
    }

    func make(using arguments: ArgumentParser.Result) -> Payload {
        let title = arguments.get(titleArgument) ?? "Default title"
        let body = arguments.get(bodyArgument) ?? "Default body"
        let isMutable = arguments.get(isMutableArgument) ?? false
        let badge = arguments.get(badgeArgument)

        return Payload(title: title, body: body, isMutable: isMutable, badge: badge)
    }
}

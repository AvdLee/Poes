//
//  Payload.swift
//  PoesCore
//
//  Created by Antoine van der Lee on 07/02/2020.
//  Copyright © 2020 AvdLee. All rights reserved.
//

import Foundation

struct Payload: Encodable {
    let aps: APS

    init(title: String, body: String, isMutable: Bool) {
        aps = APS(alert: Alert(title: title, body: body), isMutable: isMutable)
    }
}

struct APS: Encodable {
    enum CodingKeys: String, CodingKey {
        case alert
        case isMutable = "mutable-content"
    }

    let alert: Alert
    let isMutable: Bool
}

struct Alert: Encodable {
    let title: String
    let body: String
}

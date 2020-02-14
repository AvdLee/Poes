//
//  Payload.swift
//  PoesCore
//
//  Created by Antoine van der Lee on 07/02/2020.
//  Copyright © 2020 AvdLee. All rights reserved.
//

import Foundation

struct Payload: Codable {
    let aps: APS

    init(title: String, body: String, isMutable: Bool, badge: Int? = nil) {
        aps = APS(alert: Alert(title: title, body: body), isMutable: isMutable, badge: badge)
    }
}

struct APS: Codable {
    enum CodingKeys: String, CodingKey {
        case alert
        case isMutable = "mutable-content"
        case badge = "badge"
    }

    let alert: Alert
    let isMutable: Bool
    let badge: Int?
}

struct Alert: Codable {
    let title: String
    let body: String
}

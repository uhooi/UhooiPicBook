//
//  MonsterItem.swift
//
//
//  Created by uhooi on 2022/01/12.
//

import Foundation
import Shared

public struct MonsterItem {
    let name: String
    let description: String
    let baseColorCode: String
    let iconUrl: URL
    let dancingUrl: URL

    public init(entity: MonsterEntity) {
        self.name = entity.name
        self.description = entity.description
        self.baseColorCode = entity.baseColorCode
        self.iconUrl = entity.iconUrl
        self.dancingUrl = entity.dancingUrl
    }
}

extension MonsterItem: Hashable {} // For diffable data source

extension MonsterItem: Sendable {}

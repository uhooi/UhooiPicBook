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
    let iconURL: URL
    let dancingURL: URL

    public init(entity: MonsterEntity) {
        self.name = entity.name
        self.description = entity.description
        self.baseColorCode = entity.baseColorCode
        self.iconURL = entity.iconURL
        self.dancingURL = entity.dancingURL
    }
}

extension MonsterItem: Hashable {} // For diffable data source

extension MonsterItem: Sendable {}

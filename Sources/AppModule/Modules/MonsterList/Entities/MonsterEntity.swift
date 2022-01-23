//
//  MonsterEntity.swift
//  UhooiPicBook
//
//  Created by uhooi on 2020/02/28.
//

import Foundation
import Shared
import MonstersRepository

public struct MonsterEntity {
    let name: String
    let description: String
    let baseColorCode: String
    let iconURL: URL
    let dancingURL: URL

    // For unit tests
    init(
        name: String,
        description: String,
        baseColorCode: String,
        iconURL: URL,
        dancingURL: URL
    ) {
        self.name = name
        self.description = description
        self.baseColorCode = baseColorCode
        self.iconURL = iconURL
        self.dancingURL = dancingURL
    }

    public init(dto: MonsterDTO) {
        guard let iconUrl = URL(string: dto.iconUrlString) else {
            fatalError("Fail to load icon.")
        }
        guard let dancingUrl = URL(string: dto.dancingUrlString) else {
            fatalError("Fail to load dancing image.")
        }

        self.name = dto.name
        self.description = dto.description.replacingOccurrences(of: "\\n", with: "\n")
        self.baseColorCode = dto.baseColorCode
        self.iconURL = iconUrl
        self.dancingURL = dancingUrl
    }
}

extension MonsterEntity: Codable {} // For saving in UserDefaults

extension MonsterEntity: Sendable {}

extension MonsterEntity: Equatable {} // For unit tests

//
//  MonsterEntity.swift
//  UhooiPicBook
//
//  Created by uhooi on 2020/02/28.
//

import Foundation
import Shared

public struct MonsterEntity {
    let name: String
    let description: String
    let baseColorCode: String
    let iconUrl: URL
    let dancingUrl: URL
}

extension MonsterEntity: Equatable {} // For unit tests

extension MonsterEntity: Codable {} // For saving in UserDefaults

extension MonsterEntity: Sendable {}

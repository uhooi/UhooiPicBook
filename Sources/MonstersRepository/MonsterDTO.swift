//
//  MonsterDTO.swift
//  UhooiPicBook
//
//  Created by uhooi on 2020/02/28.
//

public struct MonsterDTO {
    public let name: String
    public let description: String
    public let baseColorCode: String
    public let iconURLString: String
    public let dancingURLString: String
    public let order: Int

    public init(
        name: String,
        description: String,
        baseColorCode: String,
        iconURLString: String,
        dancingURLString: String,
        order: Int
    ) {
        self.name = name
        self.description = description
        self.baseColorCode = baseColorCode
        self.iconURLString = iconURLString
        self.dancingURLString = dancingURLString
        self.order = order
    }
}

extension MonsterDTO: Sendable {}

extension MonsterDTO: Equatable {} // For unit tests

//
//  MonsterItem.swift
//
//
//  Created by uhooi on 2022/01/12.
//

import UIKit.UIImage
import Shared

public struct MonsterItem {
    enum CodingKeys: CodingKey {
        case name
        case description
        case baseColor
        case icon
        case dancingImage
    }

    let name: String
    let description: String
    let baseColor: UIColor
    let icon: UIImage
    let dancingImage: UIImage
}

extension MonsterItem: Hashable {} // For diffable data source

extension MonsterItem: Codable { // For saving in UserDefaults
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decode(String.self, forKey: .description)
        baseColor = try container.decode(CodableColor.self, forKey: .baseColor).uiColor()
        icon = try container.decode(CodableImage.self, forKey: .icon).uiImage()
        dancingImage = try container.decode(CodableImage.self, forKey: .dancingImage).uiImage()
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(description, forKey: .description)
        try container.encode(CodableColor(uiColor: baseColor), forKey: .baseColor)
        try container.encode(CodableImage(uiImage: icon), forKey: .icon)
        try container.encode(CodableImage(uiImage: dancingImage), forKey: .dancingImage)
    }
}

extension MonsterItem: Sendable {}

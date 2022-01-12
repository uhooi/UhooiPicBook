//
//  MonsterItem.swift
//
//
//  Created by uhooi on 2022/01/12.
//

import UIKit.UIImage
import Shared

public struct MonsterItem {
    let name: String
    let description: String
    let baseColor: UIColor
    let icon: UIImage
    let dancingImage: UIImage
}

extension MonsterItem: Hashable {} // For diffable data source

extension MonsterItem: Sendable {}

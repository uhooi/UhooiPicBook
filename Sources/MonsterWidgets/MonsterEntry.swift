//
//  MonsterEntry.swift
//  UhooiPicBookWidgets
//
//  Created by uhooi on 2020/12/14.
//

import class UIKit.UIImage
import WidgetKit

public struct MonsterEntry: TimelineEntry {
    public let date: Date
    public let name: String
    public let description: String
    public let icon: UIImage

    public init(
        date: Date,
        name: String,
        description: String,
        icon: UIImage
    ) {
        self.date = date
        self.name = name
        self.description = description
        self.icon = icon
    }

    public static func placeholder() -> Self {
        .init(
            date: Date(),
            name: "uhooi",
            description: "ゆかいな　みどりの　せいぶつ。\nわるそうに　みえるが　むがい。",
            icon: R.Image.uhooiIcon
        )
    }
}

//
//  MonsterEntry.swift
//  UhooiPicBookWidgets
//
//  Created by uhooi on 2020/12/14.
//

import UIKit.UIImage
import WidgetKit

struct MonsterEntry: TimelineEntry {
    let date: Date
    let name: String
    let description: String
    let icon: UIImage

    static func createDefault() -> Self {
        .init(
            date: Date(),
            name: "uhooi",
            description: "ゆかいな　みどりの　せいぶつ。\nわるそうに　みえるが　むがい。",
            icon: UIImage(named: "Uhooi")! // swiftlint:disable:this force_unwrapping
        )
    }
}

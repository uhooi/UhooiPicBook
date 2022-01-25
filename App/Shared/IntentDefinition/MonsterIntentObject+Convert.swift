//
//  MonsterIntentObject+Convert.swift
//  UhooiPicBook
//
//  Created by Takehito Koshimizu on 2020/11/14.
//

import Intents
import MonstersRepository

extension MonsterIntentObject {
    convenience init(monster: MonsterDTO) {
        self.init(identifier: monster.name, display: monster.name)
        self.name = monster.name
        self.body = monster.description // The `description` is a reserved word.
        self.baseColorCode = monster.baseColorCode
        self.iconURL = URL(string: monster.iconURLString)
        self.dancingURLString = monster.dancingURLString
        self.order = monster.order as NSNumber
    }

    func dto() -> MonsterDTO? {
        guard let name = name,
              let description = body,
              let baseColorCode = baseColorCode,
              let iconURL = iconURL,
              let dancingURLString = dancingURLString,
              let order = order
        else {
            return nil
        }
        return MonsterDTO(
            name: name,
            description: description,
            baseColorCode: baseColorCode,
            iconURLString: iconURL.absoluteString,
            dancingURLString: dancingURLString,
            order: order.intValue
        )
    }
}

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
        self.iconUrl = URL(string: monster.iconURLString)
        self.dancingUrlString = monster.dancingUrlString
        self.order = monster.order as NSNumber
    }

    func convertToDTO() -> MonsterDTO? {
        guard let name = name,
              let description = body,
              let baseColorCode = baseColorCode,
              let iconUrl = iconUrl,
              let dancingUrlString = dancingUrlString,
              let order = order
        else {
            return nil
        }
        return MonsterDTO(
            name: name,
            description: description,
            baseColorCode: baseColorCode,
            iconUrlString: iconUrl.absoluteString,
            dancingUrlString: dancingUrlString,
            order: order.intValue
        )
    }
}

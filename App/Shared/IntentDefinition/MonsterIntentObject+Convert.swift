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
        self.dancingUrlString = monster.dancingURLString
        self.order = monster.order as NSNumber
    }

    func convertToDTO() -> MonsterDTO? {
        guard let name = name,
              let description = body,
              let baseColorCode = baseColorCode,
              let iconURL = iconUrl,
              let dancingURLString = dancingUrlString,
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

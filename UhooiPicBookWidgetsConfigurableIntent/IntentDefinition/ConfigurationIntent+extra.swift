//
//  ConfigurationIntent+extra.swift
//  UhooiPicBook
//
//  Created by Takehito Koshimizu on 2020/11/22.
//

import Intents

extension ConfigurationIntent {
    func monsterDTO() -> MonsterDTO? {
        monster?.convertToDTO()
    }
}

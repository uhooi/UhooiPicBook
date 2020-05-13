//
//  TempRepository.swift
//  UhooiPicBook
//
//  Created by uhooi on 2020/05/12.
//

import Foundation

/// @mockable
protocol MonstersTempRepository {
    func loadMonster(key: String) -> MonsterEntity?
    func saveMonster(_ monster: MonsterEntity, forKey key: String)
}

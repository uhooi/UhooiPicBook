// swiftlint:disable:this file_name
//
//  TempRepository.swift
//  UhooiPicBook
//
//  Created by uhooi on 2020/05/12.
//

/// @mockable
protocol MonstersTempRepository {
    static var shared: Self { get }
    func monster(key: String) -> MonsterEntity?
    func saveMonster(_ monster: MonsterEntity, forKey key: String)
}

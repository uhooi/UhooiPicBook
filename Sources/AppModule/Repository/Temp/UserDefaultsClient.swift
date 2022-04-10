//
//  UserDefaultsClient.swift
//  UhooiPicBook
//
//  Created by uhooi on 2020/05/12.
//

import Foundation

public final class UserDefaultsClient {

    // MARK: Stored Instance Properties

    private let userDefaults = UserDefaults.standard

    // MARK: Initializers

    private init() {}

    // MARK: Other Internal Methods

    // For unit tests
    func removeAll() {
        userDefaults.dictionaryRepresentation().keys.forEach { userDefaults.removeObject(forKey: $0) }
    }
}

extension UserDefaultsClient: MonstersTempRepository {
    public static let shared = UserDefaultsClient()

    public func monster(key: String) -> MonsterEntity? {
        guard let data = userDefaults.data(forKey: key),
              let monster = try? JSONDecoder().decode(MonsterEntity.self, from: data) else {
            return nil
        }
        return monster
    }

    func saveMonster(_ monster: MonsterEntity, forKey key: String) {
        guard let data = try? JSONEncoder().encode(monster) else {
            return
        }
        userDefaults.set(data, forKey: key)
    }
}

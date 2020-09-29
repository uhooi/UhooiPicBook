//
//  UserDefaultsClient.swift
//  UhooiPicBook
//
//  Created by uhooi on 2020/05/12.
//

import Foundation

final class UserDefaultsClient {

    // MARK: Stored Instance Properties

    private let userDefaults = UserDefaults.standard

    // MARK: Other Internal Methods

    func removeAll() {
        self.userDefaults.dictionaryRepresentation().keys.forEach { self.userDefaults.removeObject(forKey: $0) }
    }

}

extension UserDefaultsClient: MonstersTempRepository {

    func loadMonster(key: String) -> MonsterEntity? {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

        guard let data = self.userDefaults.data(forKey: key),
              let monster = try? jsonDecoder.decode(MonsterEntity.self, from: data) else {
            return nil
        }
        return monster
    }

    func saveMonster(_ monster: MonsterEntity, forKey key: String) {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase

        guard let data = try? jsonEncoder.encode(monster) else {
            return
        }
        self.userDefaults.set(data, forKey: key)
    }

}

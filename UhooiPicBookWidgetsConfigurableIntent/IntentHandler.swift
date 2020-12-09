//
//  IntentHandler.swift
//  UhooiPicBookSelectIntent
//
//  Created by Takehito Koshimizu on 2020/11/14.
//

import Intents
import FirebaseCore

final class IntentHandler: INExtension, SelectMonsterIntentHandling {

    private let repository: MonstersRepository

    override init() {
        FirebaseApp.configure()
        self.repository = MonstersFirebaseClient()
        super.init()
    }

    func provideMonsterOptionsCollection(
        for intent: SelectMonsterIntent,
        with completion: @escaping (INObjectCollection<MonsterIntentObject>?, Error?) -> Void) {
        self.repository.loadMonsters { result in
            switch result {
            case let .success(monsters):
                let monsterIntentObject = monsters
                    .sorted { $0.order < $1.order }
                    .map(MonsterIntentObject.init)
                completion(INObjectCollection(items: monsterIntentObject), nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }
}

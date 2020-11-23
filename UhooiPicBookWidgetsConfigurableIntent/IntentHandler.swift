//
//  IntentHandler.swift
//  UhooiPicBookSelectIntent
//
//  Created by Takehito Koshimizu on 2020/11/14.
//

import Intents
import FirebaseCore

final class IntentHandler: INExtension, ConfigurationIntentHandling {

    private let repository: MonstersRepository

    override init() {
        FirebaseApp.configure()
        repository = MonstersFirebaseClient()
        super.init()
    }

    override func handler(for intent: INIntent) -> Any { self }

    func provideMonsterOptionsCollection(
        for intent: ConfigurationIntent,
        with completion: @escaping (INObjectCollection<INMonster>?, Error?) -> Void) {

        repository.loadMonsters { result in
            switch result.map([INMonster].orderedMonsters) {
            case let .success(items):
                completion(INObjectCollection(items: items), nil)

            case let .failure(error):
                completion(nil, error)
            }
        }
    }
}

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

    override func handler(for intent: INIntent) -> Any { self }

    func provideMonsterOptionsCollection(
        for intent: SelectMonsterIntent,
        with completion: @escaping (INObjectCollection<INMonster>?, Error?) -> Void) {
        self.repository.loadMonsters { result in
            switch result {
            case let .success(monsters):
                let inMonsters = monsters
                    .sorted { $0.order < $1.order }
                    .map(INMonster.init)
                completion(INObjectCollection(items: inMonsters), nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }
}

//
//  IntentHandler.swift
//  UhooiPicBookWidgetsConfigurableIntent
//
//  Created by Takehito Koshimizu on 2020/11/14.
//

import Intents
import FirebaseSetup

final class IntentHandler: INExtension, SelectMonsterIntentHandling {

    private let repository: MonstersRepository

    override init() {
        FirebaseSetup.configure()
        self.repository = MonstersFirebaseClient.shared
        super.init()
    }

    func provideMonsterOptionsCollection(
        for intent: SelectMonsterIntent,
        with completion: @escaping (INObjectCollection<MonsterIntentObject>?, Error?) -> Void) {
        Task {
            do {
                let monsters = try await repository.loadMonsters()
                let monsterIntentObject = monsters
                    .sorted { $0.order < $1.order }
                    .map(MonsterIntentObject.init)
                completion(INObjectCollection(items: monsterIntentObject), nil)
            } catch {
                completion(nil, error)
            }
        }
    }
}

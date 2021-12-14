//
//  IntentHandler.swift
//  UhooiPicBookWidgetsConfigurableIntent
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
        Task { [weak self] in
            guard let self = self else {
                completion(nil, nil)
                return
            }
            do {
                let monsters = try await self.repository.loadMonsters()
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

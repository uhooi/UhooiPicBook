//
//  MonsterListInteractor.swift
//  UhooiPicBook
//
//  Created by uhooi on 28/02/2020.
//  Copyright © 2020 THE Uhooi. All rights reserved.
//

import MonstersRepository

/// @mockable
protocol MonsterListInteractorInput: AnyObject {
    func monsters() async throws -> [MonsterDTO]
    func saveMonsterInSpotlight(_ monster: MonsterEntity) async
}

final class MonsterListInteractor<SR: SpotlightRepository, MR: MonstersRepository, MTR: MonstersTempRepository> {

    // MARK: Stored Instance Properties

    private weak var presenter: (any MonsterListInteractorOutput)!

    private let spotlightRepository: SR
    private let monstersRepository: MR
    private let monstersTempRepository: MTR

    // MARK: Initializer

    // No `private` for unit tests
    init(
        spotlightRepository: SR,
        monstersRepository: MR,
        monstersTempRepository: MTR
    ) {
        self.spotlightRepository = spotlightRepository
        self.monstersRepository = monstersRepository
        self.monstersTempRepository = monstersTempRepository
    }

    convenience init(spotlightRepository: SR) where MR == MonstersFirestoreClient, MTR == UserDefaultsClient {
        self.init(
            spotlightRepository: spotlightRepository,
            monstersRepository: MonstersFirestoreClient.shared,
            monstersTempRepository: UserDefaultsClient.shared
        )
    }

    // MARK: Other Internal Methods

    func inject<P: MonsterListInteractorOutput>(presenter: P) {
        self.presenter = presenter
    }
}

extension MonsterListInteractor: MonsterListInteractorInput {
    func monsters() async throws -> [MonsterDTO] {
        try await monstersRepository.monsters()
    }

    func saveMonsterInSpotlight(_ monster: MonsterEntity) async {
        let key = "spotlight_\(monster.name)"
        monstersTempRepository.saveMonster(monster, forKey: key)
        await spotlightRepository.saveMonster(monster, forKey: key)
    }
}

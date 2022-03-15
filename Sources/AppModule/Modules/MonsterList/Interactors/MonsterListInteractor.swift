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

final class MonsterListInteractor {

    // MARK: Stored Instance Properties

    private weak var presenter: (any MonsterListInteractorOutput)!

    private let monstersRepository: any MonstersRepository
    private let monstersTempRepository: any MonstersTempRepository
    private let spotlightRepository: any SpotlightRepository

    // MARK: Initializer

    init(
        spotlightRepository: any SpotlightRepository,
        monstersRepository: any MonstersRepository = MonstersFirestoreClient.shared,
        monstersTempRepository: any MonstersTempRepository = UserDefaultsClient.shared
    ) {
        self.spotlightRepository = spotlightRepository
        self.monstersRepository = monstersRepository
        self.monstersTempRepository = monstersTempRepository
    }

    // MARK: Other Internal Methods

    func inject(presenter: any MonsterListInteractorOutput) {
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

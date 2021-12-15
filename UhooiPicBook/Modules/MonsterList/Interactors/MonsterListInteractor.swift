//
//  MonsterListInteractor.swift
//  UhooiPicBook
//
//  Created by uhooi on 28/02/2020.
//  Copyright © 2020 THE Uhooi. All rights reserved.
//

/// @mockable
protocol MonsterListInteractorInput: AnyObject {
    func fetchMonsters() async throws -> [MonsterDTO]
    func saveForSpotlight(_ monster: MonsterEntity)
}

final class MonsterListInteractor {

    // MARK: Type Aliases

    // MARK: Stored Instance Properties

    weak var presenter: MonsterListInteractorOutput!

    private let monstersRepository: MonstersRepository
    private let monstersTempRepository: MonstersTempRepository
    private let spotlightRepository: SpotlightRepository

    // MARK: Computed Instance Properties

    // MARK: Initializer

    init(
        monstersRepository: MonstersRepository,
        monstersTempRepository: MonstersTempRepository,
        spotlightRepository: SpotlightRepository
    ) {
        self.monstersRepository = monstersRepository
        self.monstersTempRepository = monstersTempRepository
        self.spotlightRepository = spotlightRepository
    }

    // MARK: Other Private Methods

}

extension MonsterListInteractor: MonsterListInteractorInput {

    func fetchMonsters() async throws -> [MonsterDTO] {
        try await monstersRepository.loadMonsters()
    }

    func saveForSpotlight(_ monster: MonsterEntity) {
        let key = "spotlight_\(monster.name)"
        monstersTempRepository.saveMonster(monster, forKey: key)
        spotlightRepository.saveMonster(monster, forKey: key)
    }

}

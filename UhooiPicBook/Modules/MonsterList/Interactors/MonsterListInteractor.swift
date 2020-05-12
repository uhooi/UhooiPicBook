//
//  MonsterListInteractor.swift
//  UhooiPicBook
//
//  Created by uhooi on 28/02/2020.
//  Copyright © 2020 THE Uhooi. All rights reserved.
//

import Foundation

/// @mockable
protocol MonsterListInteractorInput: AnyObject {
    func fetchMonsters()
    func saveToSpotlight(_ monster: MonsterEntity)
}

final class MonsterListInteractor {

    // MARK: Type Aliases

    // MARK: Stored Instance Properties

    weak var presenter: MonsterListInteractorOutput!

    private let monstersRepository: MonstersRepository

    private let spotlightRepository: SpotlightRepository

    // MARK: Computed Instance Properties

    // MARK: Initializer

    init(monstersRepository: MonstersRepository, spotlightRepository: SpotlightRepository) {
        self.monstersRepository = monstersRepository
        self.spotlightRepository = spotlightRepository
    }

    // MARK: Other Private Methods

}

extension MonsterListInteractor: MonsterListInteractorInput {

    func fetchMonsters() {
        self.monstersRepository.loadMonsters { result in
            switch result {
            case let .success(monsters):
                self.presenter.monstersFetched(monsters: monsters)
            case let .failure(error):
                // TODO: エラーハンドリング
                break
            }
        }
    }

    func saveToSpotlight(_ monster: MonsterEntity) {
        self.spotlightRepository.save(monster)
    }
}

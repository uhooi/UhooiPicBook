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
}

final class MonsterListInteractor {

    // MARK: Type Aliases

    // MARK: Stored Instance Properties

    weak var presenter: MonsterListInteractorOutput!

    private let monstersRepository: MonstersRepository

    // MARK: Computed Instance Properties

    // MARK: Initializer

    init(monstersRepository: MonstersRepository) {
        self.monstersRepository = monstersRepository
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
                // TODO:
                break
            }
        }
    }

}

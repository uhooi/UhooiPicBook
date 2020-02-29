//
//  MonsterListPresenter.swift
//  UhooiPicBook
//
//  Created by uhooi on 28/02/2020.
//  Copyright © 2020 THE Uhooi. All rights reserved.
//

import Foundation

protocol MonsterListEventHandler: AnyObject {
    func viewDidLoad()
}

/// @mockable
protocol MonsterListInteractorOutput: AnyObject {
    func monstersFetched(monsters: [MonsterDTO])
}

final class MonsterListPresenter {

    // MARK: Type Aliases

    // MARK: Stored Instance Properties

    private unowned let view: MonsterListUserInterface
    private let interactor: MonsterListInteractorInput
    private let router: MonsterListRouterInput

    // MARK: Computed Instance Properties

    // MARK: Initializers

    init(view: MonsterListUserInterface, interactor: MonsterListInteractorInput, router: MonsterListRouterInput) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }

    // MARK: Other Private Methods

}

extension MonsterListPresenter: MonsterListEventHandler {

    func viewDidLoad() {
        self.interactor.fetchMonsters()
    }

}

extension MonsterListPresenter: MonsterListInteractorOutput {

    func monstersFetched(monsters: [MonsterDTO]) {
        let monsterEntities = monsters.map { convertDTOToEntity(dto: $0) }
        self.view.showMonsters(monsters: monsterEntities)
    }

    private func convertDTOToEntity(dto: MonsterDTO) -> MonsterEntity {
        MonsterEntity(icon: dto.icon, name: dto.name, description: dto.description)
    }
}

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
    func didSelectMonster(monster: MonsterEntity)
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
        self.view.startIndicator()
        self.interactor.fetchMonsters()
    }

    func didSelectMonster(monster: MonsterEntity) {
        self.router.showMonsterDetail(monster: monster)
    }

}

extension MonsterListPresenter: MonsterListInteractorOutput {

    func monstersFetched(monsters: [MonsterDTO]) {
        let monsterEntities = monsters.sorted { $0.order < $1.order } .map { convertDTOToEntity(dto: $0) }
        self.view.showMonsters(monsters: monsterEntities)
        self.view.stopIndicator()
    }

    private func convertDTOToEntity(dto: MonsterDTO) -> MonsterEntity {
        guard let iconUrl = URL(string: dto.iconUrlString) else {
            fatalError("") // TODO: エラーハンドリング
        }
        guard let dancingUrl = URL(string: dto.dancingUrlString) else {
            fatalError("") // TODO: エラーハンドリング
        }

        return MonsterEntity(name: dto.name,
                             description: dto.description.replacingOccurrences(of: "\\n", with: "\n"),
                             iconUrl: iconUrl,
                             dancingUrl: dancingUrl)
    }

}

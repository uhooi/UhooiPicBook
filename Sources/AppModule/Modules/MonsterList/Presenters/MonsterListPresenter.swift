//
//  MonsterListPresenter.swift
//  UhooiPicBook
//
//  Created by uhooi on 28/02/2020.
//  Copyright © 2020 THE Uhooi. All rights reserved.
//

import Foundation

@MainActor
protocol MonsterListEventHandler: AnyObject {
    func viewDidLoad() async

    // Menu
    func didTapContactUs()
    func didTapPrivacyPolicy()
    func didTapLicenses()
    func didTapAboutThisApp()
}

@MainActor
protocol MonsterSectionEventHandler: AnyObject {
    func didSelectMonsterAt(_ row: Int) async
}

/// @mockable
protocol MonsterListInteractorOutput: AnyObject {
}

@MainActor
final class MonsterListPresenter {

    // MARK: Stored Instance Properties

    private unowned let view: MonsterListUserInterface
    private let interactor: MonsterListInteractorInput
    private let router: MonsterListRouterInput

    private var monsters: [MonsterEntity] = []

    // MARK: Initializers

    init(
        view: MonsterListUserInterface,
        interactor: MonsterListInteractorInput,
        router: MonsterListRouterInput
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension MonsterListPresenter: MonsterListEventHandler {
    func viewDidLoad() async {
        do {
            view.startIndicator()
            let monsterDTOs = try await interactor.fetchMonsters()
            let monsterEntities = monsterDTOs
                .sorted { $0.order < $1.order }
                .map { MonsterEntity(dto: $0) }
            self.monsters = monsterEntities
            let monsterItems = monsterEntities.map { MonsterItem(entity: $0) }
            view.showMonsters(monsterItems)
            view.stopIndicator()
        } catch {
            // TODO: エラーハンドリング
            view.stopIndicator()
        }
    }

    func didTapContactUs() {
        router.showContactUs()
    }

    func didTapPrivacyPolicy() {
        router.showPrivacyPolicy()
    }

    func didTapLicenses() {
        router.showSettings()
    }

    func didTapAboutThisApp() {
        router.showAboutThisApp()
    }
}

extension MonsterListPresenter: MonsterSectionEventHandler {
    func didSelectMonsterAt(_ row: Int) async {
        let entity = monsters[row]
        router.showMonsterDetail(monster: MonsterItem(entity: entity))
        await interactor.saveForSpotlight(entity)
    }
}

extension MonsterListPresenter: MonsterListInteractorOutput {
}

//
//  MonsterListPresenter.swift
//  UhooiPicBook
//
//  Created by uhooi on 28/02/2020.
//  Copyright © 2020 THE Uhooi. All rights reserved.
//

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
    func didSelectMonster(at row: Int) async
}

/// @mockable
protocol MonsterListInteractorOutput: AnyObject {
}

@MainActor
final class MonsterListPresenter<
    View: MonsterListUserInterface,
    Interactor: MonsterListInteractorInput,
    Router: MonsterListRouterInput
> {

    // MARK: Stored Instance Properties

    private unowned let view: View
    private let interactor: Interactor
    private let router: Router

    private var monsters: [MonsterEntity] = []

    // MARK: Initializers

    init(view: View, interactor: Interactor, router: Router) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension MonsterListPresenter: MonsterListEventHandler {
    func viewDidLoad() async {
        do {
            view.startIndicator()
            let monsterDTOs = try await interactor.monsters()
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
    func didSelectMonster(at row: Int) async {
        let entity = monsters[row]
        router.showMonsterDetail(monster: MonsterItem(entity: entity))
        await interactor.saveMonsterInSpotlight(entity)
    }
}

extension MonsterListPresenter: MonsterListInteractorOutput {
}

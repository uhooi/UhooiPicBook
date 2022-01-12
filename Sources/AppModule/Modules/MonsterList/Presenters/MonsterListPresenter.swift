//
//  MonsterListPresenter.swift
//  UhooiPicBook
//
//  Created by uhooi on 28/02/2020.
//  Copyright © 2020 THE Uhooi. All rights reserved.
//

import Foundation
import MonstersFirebaseClient

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
protocol MonsterSectionEventHandler {
    func didSelectMonster(monster: MonsterEntity) async
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

    // MARK: Initializers

    init(view: MonsterListUserInterface, interactor: MonsterListInteractorInput, router: MonsterListRouterInput) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension MonsterListPresenter: MonsterListEventHandler {
    func viewDidLoad() async {
        do {
            view.startIndicator()
            let monsters = try await interactor.fetchMonsters()
            let monsterEntities = monsters
                .sorted { $0.order < $1.order }
                .map { convertDTOToEntity(dto: $0) }
            view.showMonsters(monsterEntities)
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

    // MARK: Other Private Methods

    private func convertDTOToEntity(dto: MonsterDTO) -> MonsterEntity {
        guard let iconUrl = URL(string: dto.iconUrlString) else {
            fatalError("Fail to load icon.")
        }
        guard let dancingUrl = URL(string: dto.dancingUrlString) else {
            fatalError("Fail to load dancing image.")
        }

        return MonsterEntity(
            name: dto.name,
            description: dto.description.replacingOccurrences(of: "\\n", with: "\n"),
            baseColorCode: dto.baseColorCode,
            iconUrl: iconUrl,
            dancingUrl: dancingUrl
        )
    }
}

extension MonsterListPresenter: MonsterSectionEventHandler {
    func didSelectMonster(monster: MonsterEntity) async {
        router.showMonsterDetail(monster: monster)
        await interactor.saveForSpotlight(monster)
    }
}

extension MonsterListPresenter: MonsterListInteractorOutput {
}

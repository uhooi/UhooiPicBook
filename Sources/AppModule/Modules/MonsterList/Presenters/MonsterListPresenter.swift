//
//  MonsterListPresenter.swift
//  UhooiPicBook
//
//  Created by uhooi on 28/02/2020.
//  Copyright © 2020 THE Uhooi. All rights reserved.
//

import Foundation
import MonstersFirebaseClient
import ImageCache

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

    private let monsterConverter: MonsterConverter

    private var monsters: [MonsterEntity] = []

    // MARK: Initializers

    init(
        view: MonsterListUserInterface,
        interactor: MonsterListInteractorInput,
        router: MonsterListRouterInput,
        imageCacheManager: ImageCacheManagerProtocol
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.monsterConverter = MonsterConverter(imageCacheManager: imageCacheManager)
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
            self.monsters = monsterEntities
            let monsterItems = await convertEntitiesToItems(entities: monsterEntities)
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

    private func convertEntitiesToItems(entities: [MonsterEntity]) async -> [MonsterItem] {
        var items: [MonsterItem] = []
        for entity in entities {
            items.append(await monsterConverter.convertEntityToItem(entity: entity))
        }
        return items
    }
}

extension MonsterListPresenter: MonsterSectionEventHandler {
    func didSelectMonsterAt(_ row: Int) async {
        let monster = monsters[row]
        router.showMonsterDetail(monster: await monsterConverter.convertEntityToItem(entity: monster))
        await interactor.saveForSpotlight(monster)
    }
}

extension MonsterListPresenter: MonsterListInteractorOutput {
}

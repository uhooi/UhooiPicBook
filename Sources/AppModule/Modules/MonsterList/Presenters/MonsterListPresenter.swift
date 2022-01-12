//
//  MonsterListPresenter.swift
//  UhooiPicBook
//
//  Created by uhooi on 28/02/2020.
//  Copyright © 2020 THE Uhooi. All rights reserved.
//

import Foundation
import UIKit.UIColor
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
protocol MonsterSectionEventHandler {
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

    private let imageCacheManager: ImageCacheManagerProtocol

    private var monsters: [MonsterItem] = []

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
        self.imageCacheManager = imageCacheManager
    }
}

extension MonsterListPresenter: MonsterListEventHandler {
    func viewDidLoad() async {
        do {
            view.startIndicator()
            let monsters = try await interactor.fetchMonsters()
            let monsterItems = await convertDTOsToItems(dtos: monsters.sorted { $0.order < $1.order })
            self.monsters = monsterItems
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

    private func convertDTOsToItems(dtos: [MonsterDTO]) async -> [MonsterItem] {
        var items: [MonsterItem] = []
        for dto in dtos {
            items.append(await convertDTOToItem(dto: dto))
        }
        return items
    }

    private func convertDTOToItem(dto: MonsterDTO) async -> MonsterItem {
        guard let iconUrl = URL(string: dto.iconUrlString),
              let icon = try? await imageCacheManager.cacheImage(imageUrl: iconUrl)
        else {
            fatalError("Fail to load icon.")
        }
        guard let dancingUrl = URL(string: dto.dancingUrlString),
              let dancingImage = imageCacheManager.cacheGIFImage(imageUrl: dancingUrl)
        else {
            fatalError("Fail to load dancing image.")
        }

        return MonsterItem(
            name: dto.name,
            description: dto.description.replacingOccurrences(of: "\\n", with: "\n"),
            baseColor: UIColor(hex: dto.baseColorCode),
            icon: icon,
            dancingImage: dancingImage
        )
    }
}

extension MonsterListPresenter: MonsterSectionEventHandler {
    func didSelectMonsterAt(_ row: Int) async {
        let monster = monsters[row]
        router.showMonsterDetail(monster: monster)
        await interactor.saveForSpotlight(monster)
    }
}

extension MonsterListPresenter: MonsterListInteractorOutput {
}

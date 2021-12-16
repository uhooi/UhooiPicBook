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

    // Menu
    func didTapContactUs()
    func didTapPrivacyPolicy()
    func didTapLicenses()
    func didTapAboutThisApp()
}

/// @mockable
protocol MonsterListInteractorOutput: AnyObject {
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
        self.interactor.fetchMonsters { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case let .success(monsters):
                let monsterEntities = monsters
                    .sorted { $0.order < $1.order }
                    .map { self.convertDTOToEntity(dto: $0) }
                self.view.showMonsters(monsterEntities)
                self.view.stopIndicator()
            case let .failure(error):
                // TODO: エラーハンドリング
                self.view.stopIndicator()
            }
        }
    }

    func didTapContactUs() {
        self.router.showContactUs()
    }

    func didTapPrivacyPolicy() {
        self.router.showPrivacyPolicy()
    }

    func didTapLicenses() {
        self.router.showSettings()
    }

    func didTapAboutThisApp() {
        self.router.showAboutThisApp()
    }

    func didSelectMonster(monster: MonsterEntity) {
        self.interactor.saveForSpotlight(monster)
        self.router.showMonsterDetail(monster: monster)
    }

    // MARK: Other Private Methods

    private func convertDTOToEntity(dto: MonsterDTO) -> MonsterEntity {
        guard let iconUrl = URL(string: dto.iconUrlString) else {
            fatalError("Fail to load icon.") // TODO: エラーハンドリング
        }
        guard let dancingUrl = URL(string: dto.dancingUrlString) else {
            fatalError("Fail to load dancing image.") // TODO: エラーハンドリング
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

extension MonsterListPresenter: MonsterListInteractorOutput {
}

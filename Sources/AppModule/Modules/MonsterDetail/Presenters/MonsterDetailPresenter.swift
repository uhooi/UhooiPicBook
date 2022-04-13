//
//  MonsterDetailPresenter.swift
//  UhooiPicBook
//
//  Created by uhooi on 04/03/2020.
//  Copyright © 2020 THE Uhooi. All rights reserved.
//

import UIKit.UIImage

@MainActor
protocol MonsterDetailEventHandler: AnyObject {
    func viewDidLoad()
    func didTapDancingImageView(dancingImage: UIImage?)
    func didTapShareButton(_ senderView: UIView?, name: String?, description: String?, icon: UIImage?)
}

/// @mockable
protocol MonsterDetailInteractorOutput: AnyObject {
}

@MainActor
final class MonsterDetailPresenter<
    View: MonsterDetailUserInterface,
    Interactor: MonsterDetailInteractorInput,
    Router: MonsterDetailRouterInput
> {

    // MARK: Stored Instance Properties

    private unowned let view: View
    private let interactor: Interactor
    private let router: Router

    // MARK: Initializers

    init(view: View, interactor: Interactor, router: Router) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension MonsterDetailPresenter: MonsterDetailEventHandler {
    func viewDidLoad() {
    }

    func didTapDancingImageView(dancingImage: UIImage?) {
        guard let dancingImage = dancingImage else {
            return
        }
        router.popupDancingImage(dancingImage)
    }

    func didTapShareButton(_ senderView: UIView?, name: String?, description: String?, icon: UIImage?) {
        guard let senderView = senderView,
              let name = name,
              let description = description,
              let icon = icon
        else {
            return // TODO: エラーハンドリング
        }
        let text = "\(name)\n\(description)\n\(R.LocalizedString.uhooiPicBookHashtag)"
        router.showActivity(senderView, text: text, icon: icon)
    }
}

extension MonsterDetailPresenter: MonsterDetailInteractorOutput {
}

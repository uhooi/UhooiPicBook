//
//  MonsterDetailViewController.swift
//  UhooiPicBook
//
//  Created by uhooi on 04/03/2020.
//  Copyright © 2020 THE Uhooi. All rights reserved.
//

import UIKit

/// @mockable
@MainActor
protocol MonsterDetailUserInterface: AnyObject {
}

@MainActor
final class MonsterDetailViewController: UIViewController {

    // MARK: Type Aliases

    // MARK: Stored Instance Properties

    private var presenter: MonsterDetailEventHandler!
    private var imageCacheManager: ImageCacheManagerProtocol!
    private var logger: LoggerProtocol!

    private var monster: MonsterEntity!

    // MARK: Computed Instance Properties

    // MARK: IBOutlets

    @IBOutlet private weak var iconImageView: UIImageView! {
        willSet {
            newValue.image = nil
        }
    }
    @IBOutlet private weak var dancingImageView: UIImageView! {
        willSet {
            newValue.image = nil
            newValue.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapDancingImageView(_:))))
        }
    }
    @IBOutlet private weak var nameLabel: UILabel! {
        willSet {
            newValue.text = nil
        }
    }
    @IBOutlet private weak var descriptionLabel: UILabel! {
        willSet {
            newValue.text = nil
        }
    }

    // MARK: View Life-Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        presenter.viewDidLoad()
    }

    // MARK: IBActions

    @IBAction private func didTapShareButton(_ sender: UIBarButtonItem) {
        presenter.didTapShareButton(
            sender.value(forKey: "view") as? UIView,
            name: nameLabel.text,
            description: descriptionLabel.text,
            icon: iconImageView.image
        )
    }

    // MARK: Other Internal Methods

    func inject(
        presenter: MonsterDetailEventHandler,
        imageCacheManager: ImageCacheManagerProtocol,
        monster: MonsterEntity,
        logger: LoggerProtocol = Logger.default
    ) {
        self.presenter = presenter
        self.imageCacheManager = imageCacheManager
        self.monster = monster
        self.logger = logger
    }

    // MARK: Other Private Methods

    @objc
    private func didTapDancingImageView(_ sender: UITapGestureRecognizer) {
        presenter.didTapDancingImageView(dancingImage: dancingImageView.image)
    }

    private func configureView() {
        Task {
            do {
                iconImageView.image = try await imageCacheManager.cacheImage(imageUrl: monster.iconUrl)
            } catch {
                // TODO: エラーハンドリング
                logger.exception(error, file: #file, function: #function, line: #line, column: #column)
            }
        }
        dancingImageView.image = imageCacheManager.cacheGIFImage(imageUrl: monster.dancingUrl)
        nameLabel.text = monster.name
        descriptionLabel.text = monster.description
        navigationController?.navigationBar.configureBackgroundColor(.init(hex: monster.baseColorCode))
    }

}

extension MonsterDetailViewController: MonsterDetailUserInterface {
}

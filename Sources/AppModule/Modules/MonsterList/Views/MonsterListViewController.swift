//
//  MonsterListViewController.swift
//  UhooiPicBook
//
//  Created by uhooi on 28/02/2020.
//  Copyright © 2020 THE Uhooi. All rights reserved.
//

import UIKit
import ImageCache
import Logger

/// @mockable
@MainActor
protocol MonsterListUserInterface: AnyObject {
    func showMonsters(_ monsters: [MonsterEntity])
    func startIndicator()
    func stopIndicator()
}

@MainActor
public final class MonsterListViewController: UIViewController {

    // MARK: Type Aliases

    // MARK: Stored Instance Properties

    private var presenter: MonsterListEventHandler!
    private var imageCacheManager: ImageCacheManagerProtocol!
    private var logger: LoggerProtocol!

    private var monsters: [MonsterEntity] = []

    // MARK: Computed Instance Properties

    // MARK: IBOutlets

    @IBOutlet private weak var menuButton: UIBarButtonItem! {
        willSet {
            newValue.menu = UIMenu(
                title: "",
                children: [
                    UIAction(title: R.LocalizedString.contactUs) { [weak self] _ in
                        self?.presenter.didTapContactUs()
                    },
                    UIAction(title: R.LocalizedString.privacyPolicy) { [weak self] _ in
                        self?.presenter.didTapPrivacyPolicy()
                    },
                    UIAction(title: R.LocalizedString.licenses) { [weak self] _ in
                        self?.presenter.didTapLicenses()
                    },
                    UIAction(title: R.LocalizedString.aboutThisApp) { [weak self] _ in
                        self?.presenter.didTapAboutThisApp()
                    }
                ]
            )
        }
    }

    @IBOutlet private weak var monstersCollectionView: UICollectionView! {
        willSet {
            newValue.register(
                R.Nib.monsterCollectionViewCell,
                forCellWithReuseIdentifier: "MonsterCollectionViewCell"
            )
        }
    }

    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!

    // MARK: View Life-Cycle Methods

    override public func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.tintColor = .white

        Task {
            await presenter.viewDidLoad()
        }
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.configureBackgroundColor(R.Color.navigationBar)
    }

    // MARK: IBActions

    // MARK: Other Internal Methods

    func inject(
        presenter: MonsterListEventHandler,
        imageCacheManager: ImageCacheManagerProtocol,
        logger: LoggerProtocol = Logger.default
    ) {
        self.presenter = presenter
        self.imageCacheManager = imageCacheManager
        self.logger = logger
    }

    // MARK: Other Private Methods

}

extension MonsterListViewController: UICollectionViewDataSource {

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        monsters.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MonsterCollectionViewCell", for: indexPath) as? MonsterCollectionViewCell else {
            fatalError("Fail to load MonsterCollectionViewCell.")
        }

        Task {
            do {
                let monster = monsters[indexPath.row]
                let icon = try await imageCacheManager.cacheImage(imageUrl: monster.iconUrl)
                cell.setup(name: monster.name, icon: icon, elevation: 1.0)
            } catch {
                // TODO: エラーハンドリング
                logger.exception(error, file: #file, function: #function, line: #line, column: #column)
            }
        }

        return cell
    }

}

extension MonsterListViewController: UICollectionViewDelegateFlowLayout {

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: monstersCollectionView.frame.width - 16.0 * 2, height: 116.0)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        12.0
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        12.0
    }

}

extension MonsterListViewController: UICollectionViewDelegate {

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Task {
            let monster = monsters[indexPath.row]
            await presenter.didSelectMonster(monster: monster)
        }
    }

}

extension MonsterListViewController: MonsterListUserInterface {

    func showMonsters(_ monsters: [MonsterEntity]) {
        self.monsters = monsters
        monstersCollectionView.reloadData()
        monstersCollectionView.executeCellSlideUpAnimation()
    }

    func startIndicator() {
        view.bringSubviewToFront(activityIndicatorView)
        activityIndicatorView.startAnimating()
    }

    func stopIndicator() {
        activityIndicatorView.stopAnimating()
    }

}

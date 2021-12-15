//
//  MonsterListViewController.swift
//  UhooiPicBook
//
//  Created by uhooi on 28/02/2020.
//  Copyright © 2020 THE Uhooi. All rights reserved.
//

import UIKit

/// @mockable
@MainActor
protocol MonsterListUserInterface: AnyObject {
    func showMonsters(_ monsters: [MonsterEntity])
    func startIndicator()
    func stopIndicator()
}

@MainActor
final class MonsterListViewController: UIViewController {

    // MARK: Type Aliases

    // MARK: Stored Instance Properties

    private var presenter: MonsterListEventHandler!
    private var imageCacheManager: ImageCacheManagerProtocol!

    private var monsters: [MonsterEntity] = []

    // MARK: Computed Instance Properties

    // MARK: IBOutlets

    @IBOutlet private weak var menuButton: UIBarButtonItem! {
        willSet {
            newValue.menu = UIMenu(
                title: "",
                children: [
                    UIAction(title: R.string.localizable.contactUs()) { [weak self] _ in
                        self?.presenter.didTapContactUs()
                    },
                    UIAction(title: R.string.localizable.privacyPolicy()) { [weak self] _ in
                        self?.presenter.didTapPrivacyPolicy()
                    },
                    UIAction(title: R.string.localizable.licenses()) { [weak self] _ in
                        self?.presenter.didTapLicenses()
                    },
                    UIAction(title: R.string.localizable.aboutThisApp()) { [weak self] _ in
                        self?.presenter.didTapAboutThisApp()
                    }
                ]
            )
        }
    }

    @IBOutlet private weak var monstersCollectionView: UICollectionView! {
        willSet {
            newValue.register(R.nib.monsterCollectionViewCell)
        }
    }

    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!

    // MARK: View Life-Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.tintColor = .white

        Task {
            await presenter.viewDidLoad()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.configureBackgroundColor(R.color.navigationBar())
    }

    // MARK: IBActions

    // MARK: Other Internal Methods

    func inject(presenter: MonsterListEventHandler, imageCacheManager: ImageCacheManagerProtocol) {
        self.presenter = presenter
        self.imageCacheManager = imageCacheManager
    }

    // MARK: Other Private Methods

}

extension MonsterListViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        monsters.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.monsterCollectionViewCell, for: indexPath) else {
            fatalError("Fail to load MonsterCollectionViewCell.")
        }

        Task {
            do {
                let monster = monsters[indexPath.row]
                let icon = try await imageCacheManager.cacheImage(imageUrl: monster.iconUrl)
                Task { @MainActor in
                    cell.setup(name: monster.name, icon: icon, elevation: 1.0)
                }
            } catch {
                // TODO: エラーハンドリング
                print(error)
            }
        }

        return cell
    }

}

extension MonsterListViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: monstersCollectionView.frame.width - 16.0 * 2, height: 116.0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        12.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        12.0
    }

}

extension MonsterListViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectMonster(monster: monsters[indexPath.row])
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

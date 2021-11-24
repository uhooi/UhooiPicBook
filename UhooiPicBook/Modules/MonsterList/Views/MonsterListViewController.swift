//
//  MonsterListViewController.swift
//  UhooiPicBook
//
//  Created by uhooi on 28/02/2020.
//  Copyright © 2020 THE Uhooi. All rights reserved.
//

import UIKit

/// @mockable
protocol MonsterListUserInterface: AnyObject {
    func showMonsters(_ monsters: [MonsterEntity])
    func startIndicator()
    func stopIndicator()
}

final class MonsterListViewController: UIViewController {

    // MARK: Type Aliases

    // MARK: Stored Instance Properties

    var presenter: MonsterListEventHandler!
    var imageCacheManager: ImageCacheManagerProtocol!

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

        self.navigationController?.navigationBar.tintColor = .white
        self.presenter.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.navigationBar.configureBackgroundColor(R.color.navigationBar())
    }

    // MARK: IBActions

    // MARK: Other Private Methods

}

extension MonsterListViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.monsters.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.monsterCollectionViewCell, for: indexPath) else {
            fatalError("Fail to load MonsterCollectionViewCell.")
        }

        let monster = self.monsters[indexPath.row]

        self.imageCacheManager.cacheImage(imageUrl: monster.iconUrl) { result in
            switch result {
            case let .success(icon):
                DispatchQueue.main.async {
                    cell.setup(name: monster.name, icon: icon, elevation: 1.0)
                }
            case let .failure(error):
                // TODO: エラーハンドリング
                print(error)
            }
        }

        return cell
    }

}

extension MonsterListViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: self.monstersCollectionView.frame.width - 16.0 * 2, height: 116.0)
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
        self.presenter.didSelectMonster(monster: self.monsters[indexPath.row])
    }

}

extension MonsterListViewController: MonsterListUserInterface {

    func showMonsters(_ monsters: [MonsterEntity]) {
        self.monsters = monsters
        DispatchQueue.main.async {
            self.monstersCollectionView.reloadData()
            self.monstersCollectionView.executeCellSlideUpAnimation()
        }
    }

    func startIndicator() {
        DispatchQueue.main.async {
            self.view.bringSubviewToFront(self.activityIndicatorView)
            self.activityIndicatorView.startAnimating()
        }
    }

    func stopIndicator() {
        DispatchQueue.main.async {
            self.activityIndicatorView.stopAnimating()
        }
    }

}

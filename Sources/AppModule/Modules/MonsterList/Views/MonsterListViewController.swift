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

    // MARK: Enums

    private enum CollectionSection: Int {
        case monster
    }

    // MARK: Stored Instance Properties

    private var presenter: MonsterListEventHandler!
    private var imageCacheManager: ImageCacheManagerProtocol!
    private var logger: LoggerProtocol!

    private lazy var collectionSections: [CollectionSectionProtocol] = [
        MonsterCollectionSection(presenter: presenter, imageCacheManager: imageCacheManager, logger: logger)
    ]

    private lazy var monstersCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .null, collectionViewLayout: compositionalLayout)
        collectionView.register(
            R.Nib.monsterCollectionViewCell,
            forCellWithReuseIdentifier: MonsterCollectionViewCell.reuseIdentifier
        )
        return collectionView
    }()

    private lazy var compositionalLayout: UICollectionViewCompositionalLayout = {
        UICollectionViewCompositionalLayout { [weak self] section, _ in
            self?.collectionSections[section].layoutSection(in: self?.monstersCollectionView ?? .init())
        }
    }()

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

    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!

    // MARK: View Life-Cycle Methods

    override public func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.tintColor = .white
        configureMonstersCollectionView()

        Task {
            await presenter.viewDidLoad()
        }
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.configureBackgroundColor(R.Color.navigationBar)
    }

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

    private func configureMonstersCollectionView() {
        monstersCollectionView.dataSource = self
        monstersCollectionView.delegate = self

        view.addSubview(monstersCollectionView)
        monstersCollectionView.translatesAutoresizingMaskIntoConstraints = false

        let leading = monstersCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0)
        let trailing = monstersCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
        let top = monstersCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0)
        let bottom = monstersCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        NSLayoutConstraint.activate([leading, trailing, top, bottom])
    }
}

extension MonsterListViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionSections[section].numberOfItems
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionSections[indexPath.section].collectionView(collectionView, cellForItemAt: indexPath)
    }
}

extension MonsterListViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionSections[indexPath.section].didSelectItemAt(indexPath.row)
    }
}

extension MonsterListViewController: MonsterListUserInterface {
    func showMonsters(_ monsters: [MonsterEntity]) {
        (collectionSections[CollectionSection.monster.rawValue] as? MonsterCollectionSection)?.setMonsters(monsters)
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

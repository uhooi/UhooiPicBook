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

    private enum Section: Int, CaseIterable {
        case monster
    }

    private enum Item: Hashable {
        case monster(_ monster: MonsterEntity)
    }

    // MARK: Stored Instance Properties

    private var presenter: MonsterListEventHandler!
    private var imageCacheManager: ImageCacheManagerProtocol!
    private var logger: LoggerProtocol!

    private lazy var sections: [CollectionSectionProtocol] = [
        MonsterCollectionSection(presenter: presenter)
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
            self?.sections[section].layoutSection()
        }
    }()

    private lazy var dataSource = UICollectionViewDiffableDataSource<Section, Item>(
        collectionView: monstersCollectionView) { [weak self] collectionView, indexPath, itemIdentifier in
        guard let self = self else {
            return .init()
        }
        switch itemIdentifier {
        case let .monster(monster):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MonsterCollectionViewCell.reuseIdentifier,
                for: indexPath
            ) as? MonsterCollectionViewCell else {
                fatalError("Fail to load MonsterCollectionViewCell.")
            }

            Task {
                do {
                    let icon = try await self.imageCacheManager.cacheImage(imageUrl: monster.iconUrl)
                    cell.setup(name: monster.name, icon: icon, elevation: 1.0)
                } catch {
                    // TODO: エラーハンドリング
                    self.logger.exception(error, file: #file, function: #function, line: #line, column: #column)
                }
            }

            return cell
        }
    }

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
        monstersCollectionView.delegate = self

        view.addSubview(monstersCollectionView)
        monstersCollectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            monstersCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            monstersCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            monstersCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            monstersCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func applyDataSource(monsters: [MonsterEntity]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections(Section.allCases)

        let monsterItems: [Item] = monsters.map { .monster($0) }
        snapshot.appendItems(monsterItems, toSection: .monster)

        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension MonsterListViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        sections[indexPath.section].didSelectItemAt(indexPath.row)
    }
}

extension MonsterListViewController: MonsterListUserInterface {
    func showMonsters(_ monsters: [MonsterEntity]) {
        (sections[Section.monster.rawValue] as? MonsterCollectionSection)?.setMonsters(monsters)
        applyDataSource(monsters: monsters)
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

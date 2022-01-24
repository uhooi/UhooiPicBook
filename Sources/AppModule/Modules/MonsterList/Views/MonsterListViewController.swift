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
    func showMonsters(_ monsters: [MonsterItem])
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
        case monster(_ monster: MonsterItem)
    }

    // MARK: Stored Instance Properties

    private var presenter: MonsterListEventHandler!

    private var sections: [CollectionSectionProtocol]!

    private lazy var monstersCollectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { [weak self] section, _ in
            self?.sections[section].layoutSection()
        }
        let collectionView = UICollectionView(frame: .null, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        return collectionView
    }()

    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, Item> = {
        let monsterCellRegistration = UICollectionView.CellRegistration<MonsterCollectionViewCell, MonsterItem>(
            cellNib: R.Nib.monsterCollectionViewCell) { cell, _, monster in
            cell.setup(name: monster.name, iconURL: monster.iconURL, elevation: 1.0)
        }

        return .init(collectionView: monstersCollectionView) { collectionView, indexPath, item in
            switch item {
            case let .monster(monster):
                return collectionView.dequeueConfiguredReusableCell(
                    using: monsterCellRegistration,
                    for: indexPath,
                    item: monster
                )
            }
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
        sections: [CollectionSectionProtocol],
        presenter: MonsterListEventHandler
    ) {
        self.sections = sections
        self.presenter = presenter
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

    private func applyDataSource(monsters: [MonsterItem]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections(Section.allCases)

        let monsterItems: [Item] = monsters.map { .monster($0) }
        snapshot.appendItems(monsterItems, toSection: .monster)

        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension MonsterListViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        sections[indexPath.section].didSelectItem(at: indexPath.row)
    }
}

extension MonsterListViewController: MonsterListUserInterface {
    func showMonsters(_ monsters: [MonsterItem]) {
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

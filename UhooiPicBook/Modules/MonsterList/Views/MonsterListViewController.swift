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
    //    func showMonsters(monsters: [MonsterEntity])
}

final class MonsterListViewController: UIViewController {

    // MARK: Type Aliases

    // MARK: Stored Instance Properties

    var presenter: MonsterListEventHandler!

    private var monsters: [MonsterEntity] = []

    // MARK: Computed Instance Properties

    // MARK: IBOutlets

    @IBOutlet private weak var monstersTableView: UITableView! {
        willSet {
            // TODO:
        }
    }

    // MARK: View Life-Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        self.presenter.viewDidLoad()
    }

    // MARK: IBActions

    // MARK: Other Private Methods

    private func configureView() {
    }

}

extension MonsterListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.monsters.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.monstersTableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.monsterTableViewCell, for: indexPath) else {
            fatalError("Fail to load MonsterTableViewCell.")
        }

        let monster = self.monsters[indexPath.row]
        cell.setup(icon: monster.icon, name: monster.name)

        return cell
    }

}

extension MonsterListViewController: UITableViewDelegate {
    // TODO:
}

extension MonsterListViewController: MonsterListUserInterface {
}

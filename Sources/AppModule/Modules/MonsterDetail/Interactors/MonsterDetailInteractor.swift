//
//  MonsterDetailInteractor.swift
//  UhooiPicBook
//
//  Created by uhooi on 04/03/2020.
//  Copyright © 2020 THE Uhooi. All rights reserved.
//

/// @mockable
protocol MonsterDetailInteractorInput: AnyObject {
}

final class MonsterDetailInteractor {

    // MARK: Stored Instance Properties

    weak var presenter: MonsterDetailInteractorOutput!

    // MARK: Initializer

    init() {
    }
}

extension MonsterDetailInteractor: MonsterDetailInteractorInput {
}

//
//  MonsterDetailInteractorTests.swift
//  UhooiPicBookTests
//
//  Created by uhooi on 04/03/2020.
//  Copyright © 2020 THE Uhooi. All rights reserved.
//

import XCTest
import Testing
@testable import AppModule

struct MonsterDetailInteractorTests {

    // MARK: Stored Instance Properties

    private let presenterMock: MonsterDetailInteractorOutputMock

    private let interactor: MonsterDetailInteractor

    // MARK: TestCase Life-Cycle Methods

    init() {
        self.presenterMock = MonsterDetailInteractorOutputMock()
        self.interactor = MonsterDetailInteractor()
        self.interactor.inject(presenter: self.presenterMock)
    }

    // MARK: - Test Methods

    // MARK: MonsterDetailInteractorInput
}

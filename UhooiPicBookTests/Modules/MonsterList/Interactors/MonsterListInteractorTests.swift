//
//  MonsterListInteractorTests.swift
//  UhooiPicBookTests
//
//  Created by uhooi on 28/02/2020.
//  Copyright © 2020 THE Uhooi. All rights reserved.
//

import XCTest
@testable import UhooiPicBook

final class MonsterListInteractorTests: XCTestCase {

    // MARK: Stored Instance Properties

    private var presenterMock: MonsterListInteractorOutputMock!
    private var interactor: MonsterListInteractor!

    // MARK: TestCase Life-Cycle Methods

    override func setUp() {
        reset()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // MARK: - Test Methods

    // MARK: MonsterListInteractorInput

    // MARK: - Other Private Methods

    private func reset() {
        self.presenterMock = MonsterListInteractorOutputMock()
        self.interactor = MonsterListInteractor()
        self.interactor.presenter = self.presenterMock
    }

}

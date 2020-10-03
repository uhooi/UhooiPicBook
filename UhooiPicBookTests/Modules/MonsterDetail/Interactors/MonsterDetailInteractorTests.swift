//
//  MonsterDetailInteractorTests.swift
//  UhooiPicBookTests
//
//  Created by uhooi on 04/03/2020.
//  Copyright © 2020 THE Uhooi. All rights reserved.
//

import XCTest
@testable import UhooiPicBook

final class MonsterDetailInteractorTests: XCTestCase {

    // MARK: Stored Instance Properties

    private var presenterMock: MonsterDetailInteractorOutputMock!
    private var interactor: MonsterDetailInteractor!

    // MARK: TestCase Life-Cycle Methods

    override func setUpWithError() throws {
        reset()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // MARK: - Test Methods

    // MARK: MonsterDetailInteractorInput

    // MARK: - Other Private Methods

    private func reset() {
        self.presenterMock = MonsterDetailInteractorOutputMock()
        self.interactor = MonsterDetailInteractor()
        self.interactor.presenter = self.presenterMock
    }

}

//
//  MonsterListPresenterTests.swift
//  UhooiPicBookTests
//
//  Created by uhooi on 28/02/2020.
//  Copyright © 2020 THE Uhooi. All rights reserved.
//

import XCTest
@testable import UhooiPicBook

final class MonsterListPresenterTests: XCTestCase {

    // MARK: Stored Instance Properties

    private var viewMock: MonsterListUserInterfaceMock!
    private var interactorMock: MonsterListInteractorInputMock!
    private var routerMock: MonsterListRouterInputMock!
    private var presenter: MonsterListPresenter!

    // MARK: TestCase Life-Cycle Methods

    override func setUp() {
        reset()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // MARK: - Test Methods

    // MARK: MonsterListEventHandler

    // MARK: viewDidLoad()

    func test_viewDidLoad() {
        self.presenter.viewDidLoad()

        // TODO: Assert
    }

    // MARK: MonsterListInteractorOutput

    // MARK: - Other Private Methods

    private func reset() {
        self.viewMock = MonsterListUserInterfaceMock()
        self.interactorMock = MonsterListInteractorInputMock()
        self.routerMock = MonsterListRouterInputMock()
        self.presenter = MonsterListPresenter(view: self.viewMock, interactor: self.interactorMock, router: self.routerMock)
    }

}

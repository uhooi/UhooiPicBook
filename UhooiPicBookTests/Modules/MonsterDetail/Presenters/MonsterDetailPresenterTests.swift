//
//  MonsterDetailPresenterTests.swift
//  UhooiPicBookTests
//
//  Created by uhooi on 04/03/2020.
//  Copyright © 2020 THE Uhooi. All rights reserved.
//

import XCTest
@testable import UhooiPicBook

final class MonsterDetailPresenterTests: XCTestCase {

    // MARK: Stored Instance Properties

    private var viewMock: MonsterDetailUserInterfaceMock!
    private var interactorMock: MonsterDetailInteractorInputMock!
    private var routerMock: MonsterDetailRouterInputMock!
    private var presenter: MonsterDetailPresenter!

    // MARK: TestCase Life-Cycle Methods

    override func setUp() {
        reset()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // MARK: - Test Methods

    // MARK: MonsterDetailEventHandler

    // MARK: viewDidLoad()

    func test_viewDidLoad() {
        self.presenter.viewDidLoad()

        // TODO: Assert
    }

    // MARK: MonsterDetailInteractorOutput

    // MARK: - Other Private Methods

    private func reset() {
        self.viewMock = MonsterDetailUserInterfaceMock()
        self.interactorMock = MonsterDetailInteractorInputMock()
        self.routerMock = MonsterDetailRouterInputMock()
        self.presenter = MonsterDetailPresenter(view: self.viewMock, interactor: self.interactorMock, router: self.routerMock)
    }

}

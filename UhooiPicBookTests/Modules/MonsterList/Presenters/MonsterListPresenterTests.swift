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

        XCTAssertEqual(self.viewMock.startIndicatorCallCount, 1)
        XCTAssertEqual(self.interactorMock.fetchMonstersCallCount, 1)
    }

    // MARK: MonsterListInteractorOutput
    
    // MARK: monstersFetched()
    
    func test_monstersFetched_zero() {
        let monsterDTOs: [MonsterDTO] = []
        self.viewMock.showMonstersHandler = { monsters in
            for index in 0 ..< monsterDTOs.count {
                XCTAssertEqual(monsters[index].icon, monsterDTOs[index].icon)
                XCTAssertEqual(monsters[index].name, monsterDTOs[index].name)
                XCTAssertEqual(monsters[index].description, monsterDTOs[index].description)
            }
        }
        
        self.presenter.monstersFetched(monsters: monsterDTOs)
        
        XCTAssertEqual(self.viewMock.showMonstersCallCount, 1)
        XCTAssertEqual(self.viewMock.stopIndicatorCallCount, 1)
    }
    
    func test_monstersFetched_three() {
        let uhooiDTO = MonsterDTO(icon: UIImage(), name: "uhooi", description: "uhooi's description", order: 1)
        let ayausaDTO = MonsterDTO(icon: UIImage(), name: "ayausa", description: "ayausa's description", order: 2)
        let chibirdDTO = MonsterDTO(icon: UIImage(), name: "chibird", description: "chibird's description", order: 3)
        let monsterDTOs = [uhooiDTO, ayausaDTO, chibirdDTO]
        self.viewMock.showMonstersHandler = { monsters in
            for index in 0 ..< monsterDTOs.count {
                XCTAssertEqual(monsters[index].icon, monsterDTOs[index].icon)
                XCTAssertEqual(monsters[index].name, monsterDTOs[index].name)
                XCTAssertEqual(monsters[index].description, monsterDTOs[index].description)
            }
        }
        
        self.presenter.monstersFetched(monsters: monsterDTOs)
        
        XCTAssertEqual(self.viewMock.showMonstersCallCount, 1)
        XCTAssertEqual(self.viewMock.stopIndicatorCallCount, 1)
    }

    // MARK: - Other Private Methods

    private func reset() {
        self.viewMock = MonsterListUserInterfaceMock()
        self.interactorMock = MonsterListInteractorInputMock()
        self.routerMock = MonsterListRouterInputMock()
        self.presenter = MonsterListPresenter(view: self.viewMock, interactor: self.interactorMock, router: self.routerMock)
    }

}

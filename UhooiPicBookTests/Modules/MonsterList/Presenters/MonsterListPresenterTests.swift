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
    
    // MARK: didSelectMonster()
    
    func test_didSelectMonster() {
        let uhooiEntity = MonsterEntity(name: "uhooi", description: "uhooi's description\nuhooi", baseColorCode: "#FFFFFF", iconUrl: URL(string: "https://theuhooi.com/uhooi")!, dancingUrl: URL(string: "https://theuhooi.com/uhooi-dancing")!)

        self.presenter.didSelectMonster(monster: uhooiEntity)
        
        XCTAssertEqual(self.interactorMock.saveForSpotlightCallCount, 1)
        XCTAssertEqual(self.routerMock.showMonsterDetailCallCount, 1)
    }

    // MARK: MonsterListInteractorOutput
    
    // MARK: monstersFetched()
    
    func test_monstersFetched_zero() {
        let monsterDTOs: [MonsterDTO] = []
        self.viewMock.showMonstersHandler = { monsters in
            for index in 0 ..< monsterDTOs.count {
                XCTAssertEqual(monsters[index].name, monsterDTOs[index].name)
                XCTAssertEqual(monsters[index].description, monsterDTOs[index].description)
                let iconUrl = URL(string: monsterDTOs[index].iconUrlString)
                XCTAssertEqual(monsters[index].iconUrl, iconUrl)
            }
        }
        
        self.presenter.monstersFetched(monsters: monsterDTOs)
        
        XCTAssertEqual(self.viewMock.showMonstersCallCount, 1)
        XCTAssertEqual(self.viewMock.stopIndicatorCallCount, 1)
    }
    
    func test_monstersFetched_three() {
        let uhooiDTO = MonsterDTO(name: "uhooi", description: "uhooi's description", baseColorCode: "#FFFFFF", iconUrlString: "https://theuhooi.com/uhooi", dancingUrlString: "https://theuhooi.com/uhooi-dancing", order: 1)
        let ayausaDTO = MonsterDTO(name: "ayausa", description: "ayausa's description", baseColorCode: "#FFFFFF", iconUrlString: "https://theuhooi.com/ayausa", dancingUrlString: "https://theuhooi.com/ayausa-dancing", order: 2)
        let chibirdDTO = MonsterDTO(name: "chibird", description: "chibird's description", baseColorCode: "#FFFFFF", iconUrlString: "https://theuhooi.com/chibird", dancingUrlString: "https://theuhooi.com/chibird-dancing", order: 3)
        let monsterDTOs = [uhooiDTO, ayausaDTO, chibirdDTO]
        self.viewMock.showMonstersHandler = { monsters in
            for index in 0 ..< monsterDTOs.count {
                XCTAssertEqual(monsters[index].name, monsterDTOs[index].name)
                XCTAssertEqual(monsters[index].description, monsterDTOs[index].description)
                let iconUrl = URL(string: monsterDTOs[index].iconUrlString)
                XCTAssertEqual(monsters[index].iconUrl, iconUrl)
            }
        }
        
        self.presenter.monstersFetched(monsters: monsterDTOs)
        
        XCTAssertEqual(self.viewMock.showMonstersCallCount, 1)
        XCTAssertEqual(self.viewMock.stopIndicatorCallCount, 1)
    }
    
    func test_monsterFetched_newLine() {
        typealias TestCase = (line: UInt, description: String, expect: String)
        let testCases: [TestCase] = [
            (#line, "",              ""            ),
            (#line, "¥¥n",           "¥¥n"         ),
            (#line, "\n",            "\n"          ),
            (#line, "\\n",           "\n"          ),
            // (#line, "\\\n",          "\\n"         ),
            (#line, "\\n\\n",        "\n\n"        ),
            (#line, "test\\nuhooi",  "test\nuhooi" ),
        ]
        
        for (line, description, expect) in testCases {
            reset()
            self.viewMock.showMonstersHandler = { monsterEntities in
                XCTAssertEqual(monsterEntities[0].description, expect, line: line)
            }
            let monsterDTO = MonsterDTO(name: "monster's name", description: description, baseColorCode: "#FFFFFF", iconUrlString: "https://theuhooi.com/monster", dancingUrlString: "https://theuhooi.com/monster-dancing", order: 1)

            self.presenter.monstersFetched(monsters: [monsterDTO])
            
            XCTAssertEqual(self.viewMock.showMonstersCallCount, 1)
        }
    }

    // MARK: - Other Private Methods

    private func reset() {
        self.viewMock = MonsterListUserInterfaceMock()
        self.interactorMock = MonsterListInteractorInputMock()
        self.routerMock = MonsterListRouterInputMock()
        self.presenter = MonsterListPresenter(view: self.viewMock, interactor: self.interactorMock, router: self.routerMock)
    }

}

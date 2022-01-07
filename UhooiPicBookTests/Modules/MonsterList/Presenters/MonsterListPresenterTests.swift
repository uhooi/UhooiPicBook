//
//  MonsterListPresenterTests.swift
//  UhooiPicBookTests
//
//  Created by uhooi on 28/02/2020.
//  Copyright © 2020 THE Uhooi. All rights reserved.
//

import XCTest
@testable import UhooiPicBook
import MonstersFirebaseClient

@MainActor
final class MonsterListPresenterTests: XCTestCase {

    // MARK: Stored Instance Properties

    private var viewMock: MonsterListUserInterfaceMock!
    private var interactorMock: MonsterListInteractorInputMock!
    private var routerMock: MonsterListRouterInputMock!
    private var presenter: MonsterListPresenter!

    // MARK: TestCase Life-Cycle Methods

    @MainActor
    override func setUpWithError() throws {
        reset()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // MARK: - Test Methods

    // MARK: MonsterListEventHandler

    // MARK: viewDidLoad()

    func test_viewDidLoad_success_zero() async {
        let monsterDTOs: [MonsterDTO] = []
        interactorMock.fetchMonstersHandler = { monsterDTOs }
        viewMock.showMonstersHandler = { monsters in
            for index in 0 ..< monsterDTOs.count {
                XCTAssertEqual(monsters[index].name, monsterDTOs[index].name)
                XCTAssertEqual(monsters[index].description, monsterDTOs[index].description)
                let iconUrl = URL(string: monsterDTOs[index].iconUrlString)
                XCTAssertEqual(monsters[index].iconUrl, iconUrl)
            }
        }
        
        await presenter.viewDidLoad()
        
        XCTAssertEqual(viewMock.startIndicatorCallCount, 1)
        XCTAssertEqual(interactorMock.fetchMonstersCallCount, 1)
        XCTAssertEqual(viewMock.showMonstersCallCount, 1)
        XCTAssertEqual(viewMock.stopIndicatorCallCount, 1)
    }
    
    func test_viewDidLoad_success_three() async {
        let uhooiDTO = MonsterDTO(name: "uhooi", description: "uhooi's description", baseColorCode: "#FFFFFF", iconUrlString: "https://theuhooi.com/uhooi", dancingUrlString: "https://theuhooi.com/uhooi-dancing", order: 1)
        let ayausaDTO = MonsterDTO(name: "ayausa", description: "ayausa's description", baseColorCode: "#FFFFFF", iconUrlString: "https://theuhooi.com/ayausa", dancingUrlString: "https://theuhooi.com/ayausa-dancing", order: 2)
        let chibirdDTO = MonsterDTO(name: "chibird", description: "chibird's description", baseColorCode: "#FFFFFF", iconUrlString: "https://theuhooi.com/chibird", dancingUrlString: "https://theuhooi.com/chibird-dancing", order: 3)
        let monsterDTOs = [uhooiDTO, ayausaDTO, chibirdDTO]
        interactorMock.fetchMonstersHandler = { monsterDTOs }
        viewMock.showMonstersHandler = { monsters in
            for index in 0 ..< monsterDTOs.count {
                XCTAssertEqual(monsters[index].name, monsterDTOs[index].name)
                XCTAssertEqual(monsters[index].description, monsterDTOs[index].description)
                let iconUrl = URL(string: monsterDTOs[index].iconUrlString)
                XCTAssertEqual(monsters[index].iconUrl, iconUrl)
            }
        }
        
        await presenter.viewDidLoad()
        
        XCTAssertEqual(viewMock.startIndicatorCallCount, 1)
        XCTAssertEqual(interactorMock.fetchMonstersCallCount, 1)
        XCTAssertEqual(viewMock.showMonstersCallCount, 1)
        XCTAssertEqual(viewMock.stopIndicatorCallCount, 1)
    }
    
    func test_viewDidLoad_newLine() async {
        typealias TestCase = (description: String, expected: String, line: UInt)
        let testCases: [TestCase] = [
            ("",              ""            , #line),
            ("¥¥n",           "¥¥n"         , #line),
            ("\n",            "\n"          , #line),
            ("\\n",           "\n"          , #line),
            // ("\\\n",          "\\n"         ,#line),
            ("\\n\\n",        "\n\n"        , #line),
            ("test\\nuhooi",  "test\nuhooi" , #line),
        ]
        
        for (description, expected, line) in testCases {
            reset()
            let monsterDTO = MonsterDTO(
                name: "monster's name",
                description: description,
                baseColorCode: "#FFFFFF",
                iconUrlString: "https://theuhooi.com/monster",
                dancingUrlString: "https://theuhooi.com/monster-dancing",
                order: 1
            )
            interactorMock.fetchMonstersHandler = { [monsterDTO] }
            viewMock.showMonstersHandler = { monsters in
                XCTAssertEqual(monsters[0].description, expected, line: line)
            }

            await presenter.viewDidLoad()
            
            XCTAssertEqual(viewMock.startIndicatorCallCount, 1)
            XCTAssertEqual(interactorMock.fetchMonstersCallCount, 1)
            XCTAssertEqual(viewMock.showMonstersCallCount, 1)
            XCTAssertEqual(viewMock.stopIndicatorCallCount, 1)
        }
    }
    
    func test_viewDidLoad_failure() async {
        struct TestError: Error { }
        interactorMock.fetchMonstersHandler = { throw TestError() }
        
        await presenter.viewDidLoad()
        
        XCTAssertEqual(viewMock.startIndicatorCallCount, 1)
        XCTAssertEqual(interactorMock.fetchMonstersCallCount, 1)
        XCTAssertEqual(viewMock.showMonstersCallCount, 0)
        XCTAssertEqual(viewMock.stopIndicatorCallCount, 1)
    }
    
    // MARK: didSelectMonster()
    
    func test_didSelectMonster() async {
        let uhooiEntity = MonsterEntity(name: "uhooi", description: "uhooi's description\nuhooi", baseColorCode: "#FFFFFF", iconUrl: URL(string: "https://theuhooi.com/uhooi")!, dancingUrl: URL(string: "https://theuhooi.com/uhooi-dancing")!)

        await presenter.didSelectMonster(monster: uhooiEntity)
        
        XCTAssertEqual(interactorMock.saveForSpotlightCallCount, 1)
        XCTAssertEqual(routerMock.showMonsterDetailCallCount, 1)
    }
    
    // MARK: didTapContactUs()
    
    func test_didTapContactUs() {
        presenter.didTapContactUs()
        
        XCTAssertEqual(routerMock.showContactUsCallCount, 1)
        XCTAssertEqual(routerMock.showPrivacyPolicyCallCount, 0)
        XCTAssertEqual(routerMock.showSettingsCallCount, 0)
        XCTAssertEqual(routerMock.showAboutThisAppCallCount, 0)
    }
    
    // MARK: didTapPrivacyPolicy()
    
    func test_didTapPrivacyPolicy() {
        presenter.didTapPrivacyPolicy()
        
        XCTAssertEqual(routerMock.showContactUsCallCount, 0)
        XCTAssertEqual(routerMock.showPrivacyPolicyCallCount, 1)
        XCTAssertEqual(routerMock.showSettingsCallCount, 0)
        XCTAssertEqual(routerMock.showAboutThisAppCallCount, 0)
    }
    
    // MARK: didTapLicenses()
    
    func test_didTapLicenses() {
        presenter.didTapLicenses()
        
        XCTAssertEqual(routerMock.showContactUsCallCount, 0)
        XCTAssertEqual(routerMock.showPrivacyPolicyCallCount, 0)
        XCTAssertEqual(routerMock.showSettingsCallCount, 1)
        XCTAssertEqual(routerMock.showAboutThisAppCallCount, 0)
    }
    
    // MARK: didTapAboutThisApp()
    
    func test_didTapAboutThisApp() {
        presenter.didTapAboutThisApp()
        
        XCTAssertEqual(routerMock.showContactUsCallCount, 0)
        XCTAssertEqual(routerMock.showPrivacyPolicyCallCount, 0)
        XCTAssertEqual(routerMock.showSettingsCallCount, 0)
        XCTAssertEqual(routerMock.showAboutThisAppCallCount, 1)
    }

    // MARK: MonsterListInteractorOutput

    // MARK: - Other Private Methods

    private func reset() {
        self.viewMock = MonsterListUserInterfaceMock()
        self.interactorMock = MonsterListInteractorInputMock()
        self.routerMock = MonsterListRouterInputMock()
        self.presenter = MonsterListPresenter(
            view: self.viewMock,
            interactor: self.interactorMock,
            router: self.routerMock
        )
    }

}

//
//  MonsterListPresenterTests.swift
//  UhooiPicBookTests
//
//  Created by uhooi on 28/02/2020.
//  Copyright © 2020 THE Uhooi. All rights reserved.
//

import XCTest
import Testing
@testable import AppModule
import MonstersRepository

@MainActor
struct MonsterListPresenterTests {

    // MARK: Stored Instance Properties

    private let viewMock: MonsterListUserInterfaceMock
    private let interactorMock: MonsterListInteractorInputMock
    private let routerMock: MonsterListRouterInputMock
    
    private let presenter: MonsterListPresenter<
        MonsterListUserInterfaceMock,
        MonsterListInteractorInputMock,
        MonsterListRouterInputMock
    >

    // MARK: TestCase Life-Cycle Methods

    @MainActor
    init() {
        self.viewMock = MonsterListUserInterfaceMock()
        self.interactorMock = MonsterListInteractorInputMock()
        self.routerMock = MonsterListRouterInputMock()
        self.presenter = MonsterListPresenter(
            view: self.viewMock,
            interactor: self.interactorMock,
            router: self.routerMock
        )
    }

    // MARK: - Test Methods

    // MARK: MonsterListEventHandler

    // MARK: viewDidLoad()

    @Test
    func viewDidLoad_success_zero() async {
        let monsterDTOs: [MonsterDTO] = []
        interactorMock.monstersHandler = { monsterDTOs }
        viewMock.showMonstersHandler = { monsters in
            for _ in 0 ..< monsterDTOs.count {
                Issue.record("There shouldn't be any monsters.")
            }
        }
        
        await presenter.viewDidLoad()
        
        #expect(viewMock.startIndicatorCallCount == 1)
        #expect(interactorMock.monstersCallCount == 1)
        #expect(viewMock.showMonstersCallCount == 1)
        #expect(viewMock.stopIndicatorCallCount == 1)
    }
    
    @Test
    func viewDidLoad_success_three() async {
        let uhooiDTO = MonsterDTO(name: "uhooi", description: "uhooi's description", baseColorCode: "#FFFFFF", iconURLString: "https://theuhooi.com/uhooi", dancingURLString: "https://theuhooi.com/uhooi-dancing", order: 1)
        let ayausaDTO = MonsterDTO(name: "ayausa", description: "ayausa's description", baseColorCode: "#000000", iconURLString: "https://theuhooi.com/ayausa", dancingURLString: "https://theuhooi.com/ayausa-dancing", order: 2)
        let chibirdDTO = MonsterDTO(name: "chibird", description: "chibird's description", baseColorCode: "#999999", iconURLString: "https://theuhooi.com/chibird", dancingURLString: "https://theuhooi.com/chibird-dancing", order: 3)
        let monsterDTOs = [uhooiDTO, ayausaDTO, chibirdDTO]
        interactorMock.monstersHandler = { monsterDTOs }
        viewMock.showMonstersHandler = { monsterItems in
            for index in 0 ..< monsterDTOs.count {
                let actual = MonsterItem(entity: MonsterEntity(dto: monsterDTOs[index]))
                let expected = monsterItems[index]
                #expect(actual == expected)
            }
        }
        
        await presenter.viewDidLoad()
        
        #expect(viewMock.startIndicatorCallCount == 1)
        #expect(interactorMock.monstersCallCount == 1)
        #expect(viewMock.showMonstersCallCount == 1)
        #expect(viewMock.stopIndicatorCallCount == 1)
    }
    
    @Test(arguments: zip(["", "¥¥n", "\n", "\\n", "\\n\\n", "test\\nuhooi"], ["", "¥¥n", "\n", "\n", "\n\n", "test\nuhooi"]))
    func viewDidLoad_newLine(description: String, expected: String) async {
        let monsterDTO = MonsterDTO(
            name: "monster's name",
            description: description,
            baseColorCode: "#FFFFFF",
            iconURLString: "https://theuhooi.com/monster",
            dancingURLString: "https://theuhooi.com/monster-dancing",
            order: 1
        )
        interactorMock.monstersHandler = { [monsterDTO] }
        viewMock.showMonstersHandler = { monsters in
            #expect(monsters[0].description == expected)
        }
        
        await presenter.viewDidLoad()
        
        #expect(viewMock.startIndicatorCallCount == 1)
        #expect(interactorMock.monstersCallCount == 1)
        #expect(viewMock.showMonstersCallCount == 1)
        #expect(viewMock.stopIndicatorCallCount == 1)
    }
    
    @Test
    func viewDidLoad_failure() async {
        struct TestError: Error {}
        interactorMock.monstersHandler = { throw TestError() }
        
        await presenter.viewDidLoad()
        
        #expect(viewMock.startIndicatorCallCount == 1)
        #expect(interactorMock.monstersCallCount == 1)
        #expect(viewMock.showMonstersCallCount == 0)
        #expect(viewMock.stopIndicatorCallCount == 1)
    }
    
    // MARK: didTapContactUs()
    
    @Test
    func didTapContactUs() {
        presenter.didTapContactUs()
        
        #expect(routerMock.showContactUsCallCount == 1)
        #expect(routerMock.showPrivacyPolicyCallCount == 0)
        #expect(routerMock.showSettingsCallCount == 0)
        #expect(routerMock.showAboutThisAppCallCount == 0)
    }
    
    // MARK: didTapPrivacyPolicy()
    
    @Test
    func didTapPrivacyPolicy() {
        presenter.didTapPrivacyPolicy()
        
        #expect(routerMock.showContactUsCallCount == 0)
        #expect(routerMock.showPrivacyPolicyCallCount == 1)
        #expect(routerMock.showSettingsCallCount == 0)
        #expect(routerMock.showAboutThisAppCallCount == 0)
    }
    
    // MARK: didTapLicenses()
    
    @Test
    func didTapLicenses() {
        presenter.didTapLicenses()
        
        #expect(routerMock.showContactUsCallCount == 0)
        #expect(routerMock.showPrivacyPolicyCallCount == 0)
        #expect(routerMock.showSettingsCallCount == 1)
        #expect(routerMock.showAboutThisAppCallCount == 0)
    }
    
    // MARK: didTapAboutThisApp()
    
    @Test
    func didTapAboutThisApp() {
        presenter.didTapAboutThisApp()
        
        #expect(routerMock.showContactUsCallCount == 0)
        #expect(routerMock.showPrivacyPolicyCallCount == 0)
        #expect(routerMock.showSettingsCallCount == 0)
        #expect(routerMock.showAboutThisAppCallCount == 1)
    }

    // MARK: MonsterSectionEventHandler
    
    // MARK: didSelectMonster()
    
    @Test
    func didSelectMonster() async {
        let uhooiDTO = MonsterDTO(name: "uhooi", description: "uhooi's description", baseColorCode: "#FFFFFF", iconURLString: "https://theuhooi.com/uhooi", dancingURLString: "https://theuhooi.com/uhooi-dancing", order: 1)
        let monsterDTOs = [uhooiDTO]
        interactorMock.monstersHandler = { monsterDTOs }
        viewMock.showMonstersHandler = { monsters in
            for index in 0 ..< monsterDTOs.count {
                #expect(monsters[index].name == monsterDTOs[index].name)
            }
        }
        await presenter.viewDidLoad()
        
        await presenter.didSelectMonster(at: 0)
        
        #expect(routerMock.showMonsterDetailCallCount == 1)
        #expect(interactorMock.saveMonsterInSpotlightCallCount == 1)
    }
    
    // MARK: MonsterListInteractorOutput
}

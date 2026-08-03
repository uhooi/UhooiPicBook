//
//  MonsterListInteractorTests.swift
//  UhooiPicBookTests
//
//  Created by uhooi on 28/02/2020.
//  Copyright © 2020 THE Uhooi. All rights reserved.
//

import XCTest
import Testing
@testable import AppModule
import MonstersRepository

struct MonsterListInteractorTests {

    // MARK: Stored Instance Properties

    private let presenterMock: MonsterListInteractorOutputMock
    private let monstersRepositoryMock: MonstersRepositoryMock
    private let monstersTempRepositoryMock: MonstersTempRepositoryMock
    private let spotlightRepositoryMock: SpotlightRepositoryMock

    private let interactor: MonsterListInteractor<
        SpotlightRepositoryMock,
        MonstersRepositoryMock,
        MonstersTempRepositoryMock
    >

    // MARK: TestCase Life-Cycle Methods

    init() {
        self.presenterMock = MonsterListInteractorOutputMock()
        self.monstersRepositoryMock = MonstersRepositoryMock()
        self.monstersTempRepositoryMock = MonstersTempRepositoryMock()
        self.spotlightRepositoryMock = SpotlightRepositoryMock()
        self.interactor = MonsterListInteractor(
            spotlightRepository: self.spotlightRepositoryMock,
            monstersRepository: self.monstersRepositoryMock,
            monstersTempRepository: self.monstersTempRepositoryMock
        )
        self.interactor.inject(presenter: self.presenterMock)
    }

    // MARK: - Test Methods

    // MARK: MonsterListInteractorInput
    
    // MARK: monsters()
    
    @Test
    func monsters_success() async {
        let monsterDTOs: [MonsterDTO] = []
        monstersRepositoryMock.monstersHandler = { monsterDTOs }
        
        do {
            let monsters = try await interactor.monsters()
            #expect(monsters == monsterDTOs)
        } catch {
            Issue.record("Error: \(error)")
        }
        #expect(monstersRepositoryMock.monstersCallCount == 1)
    }
    
    @Test
    func monsters_failure() async {
        struct TestError: Error {}
        monstersRepositoryMock.monstersHandler = { throw TestError() }
        
        do {
            let monsters = try await interactor.monsters()
            Issue.record("Monsters: \(monsters)")
        } catch {
            #expect(error is TestError)
        }
        #expect(monstersRepositoryMock.monstersCallCount == 1)
    }
    
    // MARK: saveMonsterInSpotlight()
    
    @Test
    func saveMonsterInSpotlight() async {
        let uhooiEntity = MonsterEntity(name: "uhooi", description: "uhooi's description\nuhooi", baseColorCode: "#FFFFFF", iconURL: URL(string: "https://theuhooi.com/uhooi")!, dancingURL: URL(string: "https://theuhooi.com/uhooi-dancing")!)
        
        await interactor.saveMonsterInSpotlight(uhooiEntity)
        
        #expect(monstersTempRepositoryMock.saveMonsterCallCount == 1)
        #expect(spotlightRepositoryMock.saveMonsterCallCount == 1)
    }
}

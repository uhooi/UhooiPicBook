//
//  MonsterListInteractorTests.swift
//  UhooiPicBookTests
//
//  Created by uhooi on 28/02/2020.
//  Copyright © 2020 THE Uhooi. All rights reserved.
//

import XCTest
@testable import AppModule
import MonstersFirebaseClient

final class MonsterListInteractorTests: XCTestCase {

    // MARK: Stored Instance Properties

    private var presenterMock: MonsterListInteractorOutputMock!
    private var monstersRepositoryMock: MonstersRepositoryMock!
    private var monstersTempRepositoryMock: MonstersTempRepositoryMock!
    private var spotlightRepositoryMock: SpotlightRepositoryMock!
    private var interactor: MonsterListInteractor!

    // MARK: TestCase Life-Cycle Methods

    override func setUpWithError() throws {
        reset()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // MARK: - Test Methods

    // MARK: MonsterListInteractorInput
    
    // MARK: fetchMonsters()
    
    func test_fetchMonsters_success() async {
        let monsterDTOs: [MonsterDTO] = []
        monstersRepositoryMock.loadMonstersHandler = { monsterDTOs }
        
        do {
            let monsters = try await interactor.fetchMonsters()
            XCTAssertEqual(monsters, monsterDTOs)
        } catch {
            XCTFail("Error: \(error)")
        }
        XCTAssertEqual(monstersRepositoryMock.loadMonstersCallCount, 1)
    }
    
    func test_fetchMonsters_failure() async {
        struct TestError: Error {}
        monstersRepositoryMock.loadMonstersHandler = { throw TestError() }
        
        do {
            let monsters = try await interactor.fetchMonsters()
            XCTFail("Monsters: \(monsters)")
        } catch {
            XCTAssertTrue(error is TestError)
        }
        XCTAssertEqual(monstersRepositoryMock.loadMonstersCallCount, 1)
    }
    
    // saveForSpotlight()
    
    func test_saveForSpotlight() async {
        let uhooiEntity = MonsterEntity(name: "uhooi", description: "uhooi's description\nuhooi", baseColorCode: "#FFFFFF", iconUrl: URL(string: "https://theuhooi.com/uhooi")!, dancingUrl: URL(string: "https://theuhooi.com/uhooi-dancing")!)
        
        await interactor.saveForSpotlight(uhooiEntity)
        
        XCTAssertEqual(monstersTempRepositoryMock.saveMonsterCallCount, 1)
        XCTAssertEqual(spotlightRepositoryMock.saveMonsterCallCount, 1)
    }

    // MARK: - Other Private Methods

    private func reset() {
        self.presenterMock = MonsterListInteractorOutputMock()
        self.monstersRepositoryMock = MonstersRepositoryMock()
        self.monstersTempRepositoryMock = MonstersTempRepositoryMock()
        self.spotlightRepositoryMock = SpotlightRepositoryMock()
        self.interactor = MonsterListInteractor(
            spotlightRepository: self.spotlightRepositoryMock,
            monstersRepository: self.monstersRepositoryMock,
            monstersTempRepository: self.monstersTempRepositoryMock
        )
        self.interactor.presenter = self.presenterMock
    }
}

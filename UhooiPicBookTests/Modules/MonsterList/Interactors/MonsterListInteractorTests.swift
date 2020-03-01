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
    private var monstersRepositoryMock: MonstersRepositoryMock!
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
    
    // MARK: fetchMonsters()
    
    func test_fetchMonsters_success() {
        let monsterDTOs: [MonsterDTO] = []
        self.monstersRepositoryMock.loadMonstersHandler = { result in
            result(.success(monsterDTOs))
        }
        
        self.interactor.fetchMonsters()
        
        XCTAssertEqual(self.presenterMock.monstersFetchedCallCount, 1)
    }
    
    func test_fetchMonsters_failure() {
        enum TestError: Error {
            case test
        }
        self.monstersRepositoryMock.loadMonstersHandler = { result in
            result(.failure(TestError.test))
        }
        
        self.interactor.fetchMonsters()
        
        XCTAssertEqual(self.presenterMock.monstersFetchedCallCount, 0)
    }

    // MARK: - Other Private Methods

    private func reset() {
        self.presenterMock = MonsterListInteractorOutputMock()
        self.monstersRepositoryMock = MonstersRepositoryMock()
        self.interactor = MonsterListInteractor(monstersRepository: self.monstersRepositoryMock)
        self.interactor.presenter = self.presenterMock
    }

}

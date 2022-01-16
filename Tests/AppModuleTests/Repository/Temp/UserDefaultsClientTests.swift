//
//  UserDefaultsClientTests.swift
//  UhooiPicBookTests
//
//  Created by uhooi on 2020/05/12.
//

import XCTest
@testable import AppModule

final class UserDefaultsClientTests: XCTestCase {

    // MARK: Stored Instance Properties
    
    private let userDefaults = UserDefaultsClient.shared
    
    // MARK: TestCase Life-Cycle Methods
    
    override func setUpWithError() throws {
        reset()
    }

    override func tearDownWithError() throws {
    }
    
    // MARK: - Test Methods
    
    func test_monster() {
        var uhooiEntity = MonsterEntity(name: "uhooi", description: "uhooi's description\nuhooi", baseColorCode: "#FFFFFF", iconUrl: URL(string: "https://theuhooi.com/uhooi")!, dancingUrl: URL(string: "https://theuhooi.com/uhooi-dancing")!)
        let key = "spotlight_\(uhooiEntity.name)"
        
        XCTContext.runActivity(named: "Unsaved") { _ in
            XCTAssertNil(userDefaults.loadMonster(key: key))
        }

        XCTContext.runActivity(named: "Add") { _ in
            userDefaults.saveMonster(uhooiEntity, forKey: key)
            XCTAssertEqual(uhooiEntity, userDefaults.loadMonster(key: key))
        }
        
        uhooiEntity = MonsterEntity(name: "uhooi", description: "uhooi's description\nuhooi", baseColorCode: "#000000", iconUrl: URL(string: "https://theuhooi.com/uhooi")!, dancingUrl: URL(string: "https://theuhooi.com/uhooi-dancing")!)
        XCTContext.runActivity(named: "Update") { _ in
            userDefaults.saveMonster(uhooiEntity, forKey: key)
            XCTAssertEqual(uhooiEntity, userDefaults.loadMonster(key: key))
        }
        
        XCTContext.runActivity(named: "Remove") { _ in
            userDefaults.removeAll()
            XCTAssertNil(userDefaults.loadMonster(key: key))
        }
    }

    // MARK: - Other Private Methods
    
    private func reset() {
        userDefaults.removeAll()
    }
}
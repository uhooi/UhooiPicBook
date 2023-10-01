//
//  UserDefaultsClientTests.swift
//  UhooiPicBookTests
//
//  Created by uhooi on 2020/05/12.
//

import XCTest
import Testing
@testable import AppModule

struct UserDefaultsClientTests {

    // MARK: Stored Instance Properties
    
    private let userDefaults = UserDefaultsClient.shared
    
    // MARK: TestCase Life-Cycle Methods
    
    init() {
        userDefaults.removeAll()
    }
    
    // MARK: - Test Methods
    
    @Test
    func monster() {
        var uhooiEntity = MonsterEntity(name: "uhooi", description: "uhooi's description\nuhooi", baseColorCode: "#FFFFFF", iconURL: URL(string: "https://theuhooi.com/uhooi")!, dancingURL: URL(string: "https://theuhooi.com/uhooi-dancing")!)
        let key = "spotlight_\(uhooiEntity.name)"
        
        // TODO: Use `XCTContext.runActivity(named:)` .
        // ref: https://github.com/apple/swift-testing/issues/42
        // Unsaved
        #expect(userDefaults.monster(key: key) == nil)

        // Add
        userDefaults.saveMonster(uhooiEntity, forKey: key)
        #expect(uhooiEntity == userDefaults.monster(key: key))
        
        // Update
        uhooiEntity = MonsterEntity(name: "uhooi", description: "uhooi's description\nuhooi", baseColorCode: "#000000", iconURL: URL(string: "https://theuhooi.com/uhooi")!, dancingURL: URL(string: "https://theuhooi.com/uhooi-dancing")!)
        userDefaults.saveMonster(uhooiEntity, forKey: key)
        #expect(uhooiEntity == userDefaults.monster(key: key))
        
        // Remove
        userDefaults.removeAll()
        #expect(userDefaults.monster(key: key) == nil)
    }
}

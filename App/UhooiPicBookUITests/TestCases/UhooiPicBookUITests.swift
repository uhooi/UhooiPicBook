//
//  UhooiPicBookUITests.swift
//  UhooiPicBookUITests
//
//  Created by uhooi on 2020/02/24.
//  Copyright © 2020 THE Uhooi. All rights reserved.
//

import XCTest

final class UhooiPicBookUITests: XCTestCase {

    // MARK: TestCase Life-Cycle Methods

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // MARK: - Test Methods
    
    func test_normal() {
        let app = XCUIApplication()
        app.launch()
        
        var monsterListPage = MonsterListPage(app: app, timeout: 3.0)
        
        var monsterDetailPage = monsterListPage
            .swipeUpMonstersCollectionViewFirstCell()
            .swipeDownMonstersCollectionViewFirstCell()
            .swipeDownMonstersCollectionViewFirstCell()
            .tapMonstersCollectionViewFirstCell()
        
        let imagePopupPage = monsterDetailPage
            .tapDancingImage()
        
        monsterDetailPage = imagePopupPage
            .tapCloseButton()
        
        let activityPage = monsterDetailPage
            .tapShareButton()
        
        monsterDetailPage = activityPage
            .tapCloseButton()
        
        monsterListPage = monsterDetailPage
            .tapBackButton()
    }

}

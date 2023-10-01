//
//  UhooiPicBookUITests.swift
//  UhooiPicBookUITests
//
//  Created by uhooi on 2020/02/24.
//  Copyright © 2020 THE Uhooi. All rights reserved.
//

import XCTest
import Testing

struct UhooiPicBookUITests {

    // MARK: - Test Methods
    
    @Test
    func normal() {
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

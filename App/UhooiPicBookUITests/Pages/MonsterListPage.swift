//
//  MonsterListPage.swift
//  UhooiPicBookUITests
//
//  Created by uhooi on 2020/04/10.
//

import XCTest

final class MonsterListPage: Page {
    
    // MARK: Stored Instance Properties

    private let app: XCUIApplication
    
    // MARK: Computed Instance Properties
    
    private var view: XCUIElement { app.otherElements["monsterList"] }
    private var monstersCollectionViewFirstCell: XCUIElement { view.collectionViews.cells.element(boundBy: 0) }
    
    // MARK: Initializers
    
    init(app: XCUIApplication, timeout: TimeInterval) {
        self.app = app
        guard view.waitForExistence(timeout: timeout) else {
            fatalError("Fail to load MonsterListPage.")
        }
    }
    
    // MARK: Other Internal Methods
    
    func swipeUpMonstersCollectionViewFirstCell() -> MonsterListPage {
        monstersCollectionViewFirstCell.swipeUp()
        return self
    }
    
    func swipeDownMonstersCollectionViewFirstCell() -> MonsterListPage {
        monstersCollectionViewFirstCell.swipeDown()
        return self
    }

    func tapMonstersCollectionViewFirstCell() -> MonsterDetailPage {
        monstersCollectionViewFirstCell.tap()
        return MonsterDetailPage(app: app, timeout: 1.0)
    }
}

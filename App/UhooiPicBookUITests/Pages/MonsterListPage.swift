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
    
    private var view: XCUIElement { self.app.otherElements["monsterList"] }
    private var monstersCollectionViewFirstCell: XCUIElement { self.view.collectionViews.cells.element(boundBy: 0) }
    
    // MARK: Initializers
    
    init(app: XCUIApplication, timeout: TimeInterval) {
        self.app = app
        guard self.view.waitForExistence(timeout: timeout) else {
            fatalError("Fail to load MonsterListPage.")
        }
    }
    
    // MARK: Other Internal Methods
    
    func swipeUpMonstersCollectionViewFirstCell() -> MonsterListPage {
        self.monstersCollectionViewFirstCell.swipeUp()
        return self
    }
    
    func swipeDownMonstersCollectionViewFirstCell() -> MonsterListPage {
        self.monstersCollectionViewFirstCell.swipeDown()
        return self
    }

    func tapMonstersCollectionViewFirstCell() -> MonsterDetailPage {
        self.monstersCollectionViewFirstCell.tap()
        return MonsterDetailPage(app: self.app, timeout: 1.0)
    }
    
    // MARK: Other Private Methods

}


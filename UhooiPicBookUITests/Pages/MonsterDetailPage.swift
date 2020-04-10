//
//  MonsterDetailPage.swift
//  UhooiPicBookUITests
//
//  Created by uhooi on 2020/04/10.
//

import XCTest

final class MonsterDetailPage: Page {
    
    // MARK: Stored Instance Properties

    private let app: XCUIApplication
    
    // MARK: Computed Instance Properties
    
    private var view: XCUIElement { self.app.otherElements["monsterDetail"] }
    private var dancingImage: XCUIElement { self.view.images["monsterDetail_dancing_image"] }
    private var backButton: XCUIElement { self.app.navigationBars["UhooiPicBook.MonsterDetailView"].buttons["Back"] }
    
    // MARK: Initializers
    
    init(app: XCUIApplication, timeout: TimeInterval) {
        self.app = app
        guard self.view.waitForExistence(timeout: timeout) else {
            fatalError("Fail to load MonsterDetailPage.")
        }
    }
    
    // MARK: Other Internal Methods
    
    func tapDancingImage() -> ImagePopupPage {
        self.dancingImage.tap()
        return ImagePopupPage(app: self.app, timeout: 1.0)
    }
    
    func tapBackButton() -> MonsterListPage {
        self.backButton.tap()
        return MonsterListPage(app: self.app, timeout: 1.0)
    }

}

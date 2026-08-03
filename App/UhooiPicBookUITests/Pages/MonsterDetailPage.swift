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
    
    private var view: XCUIElement { app.otherElements["monsterDetail"] }
    private var dancingImage: XCUIElement { view.images["monsterDetail_dancing_image"] }
    private var backButton: XCUIElement { app.navigationBars["UhooiPicBook.MonsterDetailView"].buttons["Back"] }
    private var shareButton: XCUIElement { app.navigationBars["UhooiPicBook.MonsterDetailView"].buttons["Share"] }
    
    // MARK: Initializers
    
    init(app: XCUIApplication, timeout: TimeInterval) {
        self.app = app
        guard view.waitForExistence(timeout: timeout) else {
            fatalError("Fail to load MonsterDetailPage.")
        }
    }
    
    // MARK: Other Internal Methods
    
    func tapDancingImage() -> ImagePopupPage {
        dancingImage.tap()
        return ImagePopupPage(app: app, timeout: 1.0)
    }
    
    func tapBackButton() -> MonsterListPage {
        backButton.tap()
        return MonsterListPage(app: app, timeout: 1.0)
    }
    
    func tapShareButton() -> ActivityPage {
        shareButton.tap()
        return ActivityPage(app: app, timeout: 1.0)
    }
}

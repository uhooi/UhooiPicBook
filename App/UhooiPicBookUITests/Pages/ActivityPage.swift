//
//  ActivityPage.swift
//  UhooiPicBookUITests
//
//  Created by uhooi on 2020/05/29.
//

import XCTest

final class ActivityPage: Page {
    
    // MARK: Stored Instance Properties

    private let app: XCUIApplication
    
    // MARK: Computed Instance Properties
    
    private var view: XCUIElement { app.navigationBars["UIActivityContentView"] }
    private var closeButton: XCUIElement { view.buttons["Close"] }
    
    // MARK: Initializers
    
    init(app: XCUIApplication, timeout: TimeInterval) {
        self.app = app
        guard view.waitForExistence(timeout: timeout) else {
            fatalError("Fail to load ActivityPage.")
        }
    }
    
    // MARK: Other Internal Methods

    func tapCloseButton() -> MonsterDetailPage {
        closeButton.tap()
        return MonsterDetailPage(app: app, timeout: 1.0)
    }
}

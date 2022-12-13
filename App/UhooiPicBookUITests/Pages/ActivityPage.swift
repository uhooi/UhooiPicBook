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
    
    private var view: XCUIElement { self.app.navigationBars["UIActivityContentView"] }
    private var closeButton: XCUIElement { self.view.buttons["Close"] }
    
    // MARK: Initializers
    
    init(app: XCUIApplication, timeout: TimeInterval) {
        self.app = app
        guard self.view.waitForExistence(timeout: timeout) else {
            fatalError("Fail to load ActivityPage.")
        }
    }
    
    // MARK: Other Internal Methods

    func tapCloseButton() -> MonsterDetailPage {
        self.closeButton.tap()
        return MonsterDetailPage(app: self.app, timeout: 1.0)
    }

}

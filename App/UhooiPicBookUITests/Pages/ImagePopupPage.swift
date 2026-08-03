//
//  ImagePopupPage.swift
//  UhooiPicBookUITests
//
//  Created by uhooi on 2020/04/10.
//

import XCTest

final class ImagePopupPage: Page {
    
    // MARK: Stored Instance Properties

    private let app: XCUIApplication
    
    // MARK: Computed Instance Properties
    
    private var view: XCUIElement { app.otherElements["imagePopup"] }
    private var closeButton: XCUIElement { view.buttons["imagePopup_close_button"] }
    
    // MARK: Initializers
    
    init(app: XCUIApplication, timeout: TimeInterval) {
        self.app = app
        guard view.waitForExistence(timeout: timeout) else {
            fatalError("Fail to load ImagePopupPage.")
        }
    }
    
    // MARK: Other Internal Methods
    
    func tapCloseButton() -> MonsterDetailPage {
        closeButton.tap()
        return MonsterDetailPage(app: app, timeout: 1.0)
    }
}

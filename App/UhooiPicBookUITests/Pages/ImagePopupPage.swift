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
    
    private var view: XCUIElement { self.app.otherElements["imagePopup"] }
    private var closeButton: XCUIElement { self.view.buttons["imagePopup_close_button"] }
    
    // MARK: Initializers
    
    init(app: XCUIApplication, timeout: TimeInterval) {
        self.app = app
        guard self.view.waitForExistence(timeout: timeout) else {
            fatalError("Fail to load ImagePopupPage.")
        }
    }
    
    // MARK: Other Internal Methods
    
    func tapCloseButton() -> MonsterDetailPage {
        self.closeButton.tap()
        return MonsterDetailPage(app: self.app, timeout: 1.0)
    }

}

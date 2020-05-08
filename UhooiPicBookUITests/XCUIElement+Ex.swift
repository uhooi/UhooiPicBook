//
//  XCUIElement+Ex.swift
//  UhooiPicBookUITests
//
//  Created by uhooi on 2020/04/10.
//

import XCTest

extension XCUIElement {
    
    func inputText(_ text: String) {
        tap()
        typeText(text)
    }

}

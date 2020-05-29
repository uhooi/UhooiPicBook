//
//  MonsterDetailPresenterTests.swift
//  UhooiPicBookTests
//
//  Created by uhooi on 04/03/2020.
//  Copyright © 2020 THE Uhooi. All rights reserved.
//

import XCTest
@testable import UhooiPicBook

final class MonsterDetailPresenterTests: XCTestCase {

    // MARK: Stored Instance Properties

    private var viewMock: MonsterDetailUserInterfaceMock!
    private var interactorMock: MonsterDetailInteractorInputMock!
    private var routerMock: MonsterDetailRouterInputMock!
    private var presenter: MonsterDetailPresenter!

    // MARK: TestCase Life-Cycle Methods

    override func setUp() {
        reset()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // MARK: - Test Methods

    // MARK: MonsterDetailEventHandler

    // MARK: viewDidLoad()

    func test_viewDidLoad() {
        self.presenter.viewDidLoad()
    }
    
    // MARK: didTapDancingImageView()
    
    func test_didTapDancingImageView_notNil() {
        self.presenter.didTapDancingImageView(dancingImage: UIImage())
        
        XCTAssertEqual(self.routerMock.popupDancingImageCallCount, 1)
    }
    
    func test_didTapDancingImageView_nil() {
        self.presenter.didTapDancingImageView(dancingImage: nil)
        
        XCTAssertEqual(self.routerMock.popupDancingImageCallCount, 0)
    }
    
    // MARK: didTapShareButton()
    
    func test_didTapShareButton_one_nil() {
        typealias TestCase = (name: String?, description: String?, icon: UIImage?, line: UInt)
        let testCases: [TestCase] = [
            (nil, "概要", UIImage(), #line),
            ("名前", nil, UIImage(), #line),
            ("名前", "概要", nil, #line)
        ]
        
        for (name, description, icon, line) in testCases {
            self.presenter.didTapShareButton(name: name, description: description, icon: icon)
            XCTAssertEqual(self.routerMock.showActivityCallCount, 0, line: line)
        }
    }
    
    func test_didTapShareButton_all_notNil() {
        let name = "名前"
        let description = "概要"
        let icon = UIImage()
        self.routerMock.showActivityHandler = { text, image in
            XCTAssertEqual(text, "\(name)\n\(description)\n#UhooiPicBook")
            XCTAssertEqual(image, icon)
        }
        
        self.presenter.didTapShareButton(name: name, description: description, icon: icon)

        XCTAssertEqual(self.routerMock.showActivityCallCount, 1)
    }

    // MARK: MonsterDetailInteractorOutput

    // MARK: - Other Private Methods

    private func reset() {
        self.viewMock = MonsterDetailUserInterfaceMock()
        self.interactorMock = MonsterDetailInteractorInputMock()
        self.routerMock = MonsterDetailRouterInputMock()
        self.presenter = MonsterDetailPresenter(view: self.viewMock, interactor: self.interactorMock, router: self.routerMock)
    }

}

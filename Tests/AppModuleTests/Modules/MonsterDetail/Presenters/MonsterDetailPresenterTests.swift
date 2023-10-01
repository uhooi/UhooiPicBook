//
//  MonsterDetailPresenterTests.swift
//  UhooiPicBookTests
//
//  Created by uhooi on 04/03/2020.
//  Copyright © 2020 THE Uhooi. All rights reserved.
//

import XCTest
import Testing
@testable import AppModule

@MainActor
struct MonsterDetailPresenterTests {

    // MARK: Stored Instance Properties

    private let viewMock: MonsterDetailUserInterfaceMock
    private let interactorMock: MonsterDetailInteractorInputMock
    private let routerMock: MonsterDetailRouterInputMock

    private let presenter: MonsterDetailPresenter<
        MonsterDetailUserInterfaceMock,
        MonsterDetailInteractorInputMock,
        MonsterDetailRouterInputMock
    >

    // MARK: TestCase Life-Cycle Methods

    @MainActor
    init() {
        self.viewMock = MonsterDetailUserInterfaceMock()
        self.interactorMock = MonsterDetailInteractorInputMock()
        self.routerMock = MonsterDetailRouterInputMock()
        self.presenter = MonsterDetailPresenter(
            view: self.viewMock,
            interactor: self.interactorMock,
            router: self.routerMock
        )
    }

    // MARK: - Test Methods

    // MARK: MonsterDetailEventHandler

    // MARK: viewDidLoad()

    @Test
    func viewDidLoad() {
        presenter.viewDidLoad()
    }
    
    // MARK: didTapDancingImageView()
    
    @Test
    func didTapDancingImageView_notNil() {
        presenter.didTapDancingImageView(dancingImage: UIImage())
        
        #expect(routerMock.popupDancingImageCallCount == 1)
    }
    
    @Test
    func didTapDancingImageView_nil() {
        presenter.didTapDancingImageView(dancingImage: nil)
        
        #expect(routerMock.popupDancingImageCallCount == 0)
    }
    
    // MARK: didTapShareButton()
    
    // FIXME: A build error occurs.
    // ref: https://github.com/apple/swift-testing/issues/41
//    struct DidTapShareButtonOneNilArgument {
//        let senderView: UIView?
//        let name: String?
//        let description: String?
//        let icon: UIImage?
//    }
//    @Test(arguments: [
//        DidTapShareButtonOneNilArgument(senderView: nil, name: "name", description: "description", icon: UIImage()),
//        DidTapShareButtonOneNilArgument(senderView: UIView(), name: nil, description: "description", icon: UIImage()),
//        DidTapShareButtonOneNilArgument(senderView: UIView(), name: "name", description: nil, icon: UIImage()),
//        DidTapShareButtonOneNilArgument(senderView: UIView(), name: "name", description: "description", icon: nil),
//    ])
//    func didTapShareButton_one_nil(_ argument: DidTapShareButtonOneNilArgument) {
//        presenter.didTapShareButton(argument.senderView, name: argument.name, description: argument.description, icon: argument.icon)
//        #expect(routerMock.showActivityCallCount == 0)
//    }
    
    @Test
    func didTapShareButton_all_notNil() {
        let senderView = UIView()
        let name = "name"
        let description = "description"
        let icon = UIImage()
        routerMock.showActivityHandler = { sourceView, text, image in
            #expect(text == "\(name)\n\(description)\n#UhooiPicBook")
            #expect(sourceView == senderView)
            #expect(image == icon)
        }
        
        presenter.didTapShareButton(senderView, name: name, description: description, icon: icon)

        #expect(routerMock.showActivityCallCount == 1)
    }

    // MARK: MonsterDetailInteractorOutput
}

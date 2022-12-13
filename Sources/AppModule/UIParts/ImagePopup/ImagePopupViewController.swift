//
//  ImagePopupViewController.swift
//  UhooiPicBook
//
//  Created by uhooi on 2020/03/15.
//

import UIKit

@MainActor
final class ImagePopupViewController: UIViewController {

    // MARK: Stored Instance Properties

    var image: UIImage!

    // MARK: IBOutlets

    @IBOutlet private weak var imageView: UIImageView! {
        willSet {
            newValue.image = nil
        }
    }

    // MARK: View Life-Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }

    // MARK: IBActions

    @IBAction private func didTapCloseButton(_ sender: Any) {
        dismiss(animated: false)
    }

    // MARK: Other Private Methods

    private func configureView() {
        imageView.image = image
    }
}

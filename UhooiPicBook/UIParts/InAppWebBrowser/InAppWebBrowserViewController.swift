//
//  InAppWebBrowserViewController.swift
//  UhooiPicBook
//
//  Created by uhooi on 27/02/2021.
//  Copyright © 2021 THE Uhooi. All rights reserved.
//

import UIKit
import WebKit

final class InAppWebBrowserViewController: UIViewController {

    // MARK: Type Aliases

    // MARK: Stored Instance Properties

    var url: URL!

    private var progressView = UIProgressView(progressViewStyle: .bar)
    private var estimatedProgressObservation: NSKeyValueObservation?

    // MARK: Computed Instance Properties

    // MARK: IBOutlets

    @IBOutlet private weak var webView: WKWebView!

    // MARK: View Life-Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        loadWebView()
    }

    // MARK: IBActions

    // MARK: Other Private Methods

    private func configureView() {
        configureProgressView()
        configureWebView()
    }

    private func configureProgressView() {
        self.progressView.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: 0.0)
        self.view.addSubview(self.progressView)
    }

    private func configureWebView() {
        observeWebView()
    }

    private func observeWebView() {
        self.estimatedProgressObservation = self.webView.observe(\.estimatedProgress, options: [.new]) { [weak self] webView, _ in
            guard let self = self else {
                return
            }
            // swiftlint:disable:next trailing_closure
            UIView.animate(
                withDuration: 0.33,
                animations: {
                    self.progressView.alpha = 1.0
                }
            )
            self.progressView.setProgress(Float(webView.estimatedProgress), animated: true)

            if webView.estimatedProgress >= 1.0 {
                UIView.animate(
                    withDuration: 0.33,
                    animations: {
                        self.progressView.alpha = 0.0
                    },
                    completion: { _ in
                        self.progressView.setProgress(0.0, animated: false)
                    }
                )
            }
        }
    }

    private func loadWebView() {
        let request = URLRequest(url: self.url)
        self.webView.load(request)
    }

}

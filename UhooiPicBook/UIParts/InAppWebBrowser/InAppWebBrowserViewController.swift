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

    // MARK: Computed Instance Properties

    // MARK: IBOutlets

    @IBOutlet private weak var webView: WKWebView!

    // MARK: View Life-Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        guard let keyPath = keyPath else {
            assertionFailure("Fail to unwrap `keyPath`.")
            return
        }

        switch keyPath {
        case #keyPath(WKWebView.isLoading):
            if self.webView.isLoading {
                self.progressView.alpha = 1.0
                self.progressView.setProgress(0.1, animated: true)
            } else {
                UIView.animate(
                    withDuration: 0.3,
                    animations: {
                        self.progressView.alpha = 0.0
                    },
                    completion: { _ in
                        self.progressView.setProgress(0.0, animated: false)
                    }
                )
            }
        case #keyPath(WKWebView.estimatedProgress):
            self.progressView.setProgress(Float(self.webView.estimatedProgress), animated: true)
        default:
            // Do nothing
            break
        }
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
        self.webView.addObserver(self, forKeyPath: #keyPath(WKWebView.isLoading), options: .new, context: nil)
        self.webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)

        let request = URLRequest(url: self.url)
        self.webView.load(request)
    }

}

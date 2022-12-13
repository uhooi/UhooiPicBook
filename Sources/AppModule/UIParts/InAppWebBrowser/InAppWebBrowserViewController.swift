//
//  InAppWebBrowserViewController.swift
//  UhooiPicBook
//
//  Created by uhooi on 27/02/2021.
//  Copyright © 2021 THE Uhooi. All rights reserved.
//

import UIKit
import WebKit

@MainActor
final class InAppWebBrowserViewController: UIViewController {

    // MARK: Stored Instance Properties

    var url: URL!

    private var progressView = UIProgressView(progressViewStyle: .bar)
    private var estimatedProgressObservation: NSKeyValueObservation?

    // MARK: IBOutlets

    @IBOutlet private weak var webView: WKWebView!

    // MARK: View Life-Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        loadWebView()
    }

    // MARK: Other Private Methods

    private func configureView() {
        configureProgressView()
        configureWebView()
    }

    private func configureProgressView() {
        progressView.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: 0.0)
        view.addSubview(progressView)
    }

    private func configureWebView() {
        observeWebView()
    }

    private func observeWebView() {
        estimatedProgressObservation = webView.observe(\.estimatedProgress, options: [.new]) { @MainActor [weak self] webView, _ in
            UIView.animate(withDuration: 0.33) { [weak self] in
                self?.progressView.alpha = 1.0
            }
            self?.progressView.setProgress(Float(webView.estimatedProgress), animated: true)

            if webView.estimatedProgress >= 1.0 {
                UIView.animate(withDuration: 0.33) { [weak self] in
                    self?.progressView.alpha = 0.0
                } completion: { [weak self] _ in
                    self?.progressView.setProgress(0.0, animated: false)
                }
            }
        }
    }

    private func loadWebView() {
        let request = URLRequest(url: url)
        _ = webView.load(request)
    }
}

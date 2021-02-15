//
// Copyright © 2021 Stream.io Inc. All rights reserved.
//

import StreamChat
import UIKit
import WebKit

internal class ChatMessageAttachmentPreviewVC<ExtraData: ExtraDataTypes>: ViewController, WKNavigationDelegate, UIConfigProvider {
    internal var content: URL? {
        didSet { updateContentIfNeeded() }
    }

    // MARK: - Subviews

    internal private(set) lazy var webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        .withoutAutoresizingMaskConstraints

    internal private(set) lazy var activityIndicatorView = UIActivityIndicatorView(style: .gray)

    private lazy var closeButton = UIBarButtonItem(
        image: uiConfig.images.close,
        style: .plain,
        target: self,
        action: #selector(close)
    )

    private lazy var goBackButton = UIBarButtonItem(
        title: "←",
        style: .plain,
        target: self,
        action: #selector(goBack)
    )

    private lazy var goForwardButton = UIBarButtonItem(
        title: "→",
        style: .plain,
        target: self,
        action: #selector(goForward)
    )

    // MARK: - Life Cycle

    override internal func defaultAppearance() {
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = closeButton
        navigationItem.rightBarButtonItems = [
            goForwardButton,
            goBackButton,
            UIBarButtonItem(customView: activityIndicatorView)
        ]
    }

    override internal func setUp() {
        super.setUp()

        webView.navigationDelegate = self
    }

    override internal func setUpLayout() {
        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.topAnchor.pin(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.pin(equalTo: view.leadingAnchor),
            webView.trailingAnchor.pin(equalTo: view.trailingAnchor),
            webView.bottomAnchor.pin(equalTo: view.bottomAnchor)
        ])
    }

    override internal func updateContent() {
        goBackButton.isEnabled = false
        goForwardButton.isEnabled = false
        title = content?.absoluteString

        if let url = content {
            webView.load(URLRequest(url: url))
        } else {
            activityIndicatorView.stopAnimating()
        }
    }

    // MARK: Actions

    @objc internal func goBack() {
        if let item = webView.backForwardList.backItem {
            webView.go(to: item)
        }
    }

    @objc internal func goForward() {
        if let item = webView.backForwardList.forwardItem {
            webView.go(to: item)
        }
    }

    @objc internal func close() {
        dismiss(animated: true)
    }

    // MARK: - WKNavigationDelegate

    internal func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activityIndicatorView.startAnimating()
    }

    internal func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicatorView.stopAnimating()

        webView.evaluateJavaScript("document.title") { data, _ in
            if let title = data as? String, !title.isEmpty {
                self.title = title
            }
        }

        goBackButton.isEnabled = webView.canGoBack
        goForwardButton.isEnabled = webView.canGoForward
    }
}

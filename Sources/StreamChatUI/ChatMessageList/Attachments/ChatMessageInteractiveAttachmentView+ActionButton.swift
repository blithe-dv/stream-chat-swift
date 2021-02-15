//
// Copyright © 2021 Stream.io Inc. All rights reserved.
//

import StreamChat
import UIKit

extension _ChatMessageInteractiveAttachmentView {
    internal class ActionButton: Button, UIConfigProvider {
        internal var content: Content? {
            didSet { updateContentIfNeeded() }
        }

        // MARK: - Overrides

        internal var defaultIntrinsicContentSize = CGSize(width: UIView.noIntrinsicMetric, height: 48)
        override internal var intrinsicContentSize: CGSize {
            defaultIntrinsicContentSize
        }

        override internal func defaultAppearance() {
            titleLabel?.font = uiConfig.font.body
        }

        override internal func setUp() {
            super.setUp()

            addTarget(self, action: #selector(didTouchUpInside), for: .touchUpInside)
        }

        override internal func updateContent() {
            let titleColor = content?.action.style == .primary ?
                tintColor :
                uiConfig.colorPalette.subtitleText

            setTitle(content?.action.text, for: .normal)
            setTitleColor(titleColor, for: .normal)
            setTitleColor(
                titleColor.map(uiConfig.colorPalette.highlightedColorForColor),
                for: .highlighted
            )
            setTitleColor(
                titleColor.map(uiConfig.colorPalette.highlightedColorForColor),
                for: .selected
            )
        }
        
        override internal func tintColorDidChange() {
            super.tintColorDidChange()

            updateContentIfNeeded()
        }

        // MARK: - Actions

        @objc internal func didTouchUpInside() {
            content?.didTap()
        }
    }
}

// MARK: - Content

extension _ChatMessageInteractiveAttachmentView.ActionButton {
    internal struct Content {
        internal let action: AttachmentAction
        internal let didTap: () -> Void

        internal init(action: AttachmentAction, didTap: @escaping () -> Void) {
            self.action = action
            self.didTap = didTap
        }
    }
}

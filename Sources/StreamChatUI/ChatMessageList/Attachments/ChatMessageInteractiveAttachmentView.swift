//
// Copyright © 2021 Stream.io Inc. All rights reserved.
//

import StreamChat
import UIKit

internal typealias ChatMessageInteractiveAttachmentView = _ChatMessageInteractiveAttachmentView<NoExtraData>

internal class _ChatMessageInteractiveAttachmentView<ExtraData: ExtraDataTypes>: View, UIConfigProvider {
    internal var content: _ChatMessageAttachmentListViewData<ExtraData>.ItemData? {
        didSet { updateContentIfNeeded() }
    }

    // MARK: - Subviews

    internal private(set) lazy var preview = uiConfig
        .messageList
        .messageContentSubviews
        .attachmentSubviews
        .giphyAttachmentView
        .init()
        .withoutAutoresizingMaskConstraints

    internal private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = uiConfig.font.bodyItalic
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .center
        return label.withoutAutoresizingMaskConstraints
    }()

    internal private(set) lazy var separator = UIView()
        .withoutAutoresizingMaskConstraints

    internal private(set) lazy var actionsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 1
        return stack.withoutAutoresizingMaskConstraints
    }()

    // MARK: - Overrides

    override internal func defaultAppearance() {
        preview.layer.cornerRadius = 8
        preview.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        preview.clipsToBounds = true

        separator.backgroundColor = uiConfig.colorPalette.border
    }

    override internal func setUpLayout() {
        addSubview(preview)
        addSubview(titleLabel)
        addSubview(separator)
        addSubview(actionsStackView)

        NSLayoutConstraint.activate([
            preview.leadingAnchor.pin(equalTo: layoutMarginsGuide.leadingAnchor),
            preview.trailingAnchor.pin(equalTo: layoutMarginsGuide.trailingAnchor),
            preview.topAnchor.pin(equalTo: layoutMarginsGuide.topAnchor),
            preview.heightAnchor.pin(equalTo: preview.widthAnchor),
            
            titleLabel.topAnchor.pin(equalToSystemSpacingBelow: preview.bottomAnchor, multiplier: 1),
            titleLabel.leadingAnchor.pin(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.pin(equalTo: trailingAnchor),
            
            separator.topAnchor.pin(equalToSystemSpacingBelow: titleLabel.bottomAnchor, multiplier: 1),
            separator.leadingAnchor.pin(equalTo: leadingAnchor),
            separator.trailingAnchor.pin(equalTo: trailingAnchor),
            separator.heightAnchor.pin(equalToConstant: 1),
            
            actionsStackView.topAnchor.pin(equalTo: separator.bottomAnchor),
            actionsStackView.leadingAnchor.pin(equalTo: leadingAnchor),
            actionsStackView.trailingAnchor.pin(equalTo: trailingAnchor),
            actionsStackView.bottomAnchor.pin(equalTo: bottomAnchor)
        ])
    }

    override internal func updateContent() {
        preview.content = content?.attachment

        titleLabel.text = "\"" + (content?.attachment.title ?? "") + "\""

        actionsStackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }

        content?.attachment.actions
            .map(createActionButton)
            .forEach(actionsStackView.addArrangedSubview)
    }

    // MARK: - Private

    private func createActionButton(for action: AttachmentAction) -> ActionButton {
        let button = uiConfig
            .messageList
            .messageContentSubviews
            .attachmentSubviews
            .interactiveAttachmentActionButton
            .init()

        button.content = .init(action: action) { [weak self] in
            self?.content?.didTapOnAttachmentAction(action)
        }

        return button
    }
}

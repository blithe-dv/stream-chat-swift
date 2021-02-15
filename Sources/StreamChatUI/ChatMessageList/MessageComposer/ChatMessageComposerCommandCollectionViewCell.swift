//
// Copyright © 2021 Stream.io Inc. All rights reserved.
//

import StreamChat
import UIKit

internal typealias ChatMessageComposerCommandCellView = _ChatMessageComposerCommandCellView<NoExtraData>

internal class _ChatMessageComposerCommandCellView<ExtraData: ExtraDataTypes>: View, UIConfigProvider {
    // MARK: Properties

    internal var commandImageHeight: CGFloat = 24

    internal var command: Command? {
        didSet {
            updateContentIfNeeded()
        }
    }

    internal private(set) lazy var commandImageView: UIImageView = UIImageView().withoutAutoresizingMaskConstraints
    internal private(set) lazy var commandNameLabel: UILabel = UILabel().withoutAutoresizingMaskConstraints
    internal private(set) lazy var commandNameSubtitleLabel: UILabel = UILabel().withoutAutoresizingMaskConstraints
    private lazy var textStackView: UIStackView = UIStackView().withoutAutoresizingMaskConstraints

    // MARK: - Appearance

    override internal func defaultAppearance() {
        backgroundColor = .clear

        commandNameLabel.font = uiConfig.font.bodyBold

        commandNameSubtitleLabel.font = uiConfig.font.body
        commandNameSubtitleLabel.textColor = uiConfig.colorPalette.subtitleText

        commandNameLabel.textColor = uiConfig.colorPalette.text
    }

    override internal func setUpLayout() {
        addSubview(commandImageView)
        setupLeftImageViewConstraints()

        addSubview(textStackView)
        setupStack()
    }

    override internal func updateContent() {
        guard let command = command else { return }
        commandNameSubtitleLabel.text = "/\(command.name) \(command.args)"
        commandNameLabel.text = command.name.firstUppercased

        commandImageView.image = uiConfig.images.commandIcons[command.name.lowercased()]
            ?? uiConfig.images.messageComposerCommandFallback
    }

    // MARK: Private

    private func setupLeftImageViewConstraints() {
        commandImageView.leadingAnchor.pin(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        commandImageView.topAnchor.pin(equalTo: layoutMarginsGuide.topAnchor).isActive = true
        commandImageView.bottomAnchor.pin(equalTo: layoutMarginsGuide.bottomAnchor).isActive = true
        commandImageView.widthAnchor.pin(equalTo: commandImageView.heightAnchor).isActive = true
        commandImageView.heightAnchor.pin(equalToConstant: 24).isActive = true
    }

    private func setupStack() {
        textStackView.axis = .horizontal
        textStackView.distribution = .equalSpacing
        textStackView.alignment = .leading
        textStackView.spacing = UIStackView.spacingUseSystem

        textStackView.addArrangedSubview(commandNameLabel)
        textStackView.addArrangedSubview(commandNameSubtitleLabel)
        textStackView.leadingAnchor.pin(
            equalToSystemSpacingAfter: commandImageView.trailingAnchor,
            multiplier: 1
        ).isActive = true
        textStackView.centerYAnchor.pin(equalTo: commandImageView.centerYAnchor).isActive = true
    }
}

internal typealias ChatMessageComposerCommandCollectionViewCell = _ChatMessageComposerCommandCollectionViewCell<NoExtraData>

internal class _ChatMessageComposerCommandCollectionViewCell<ExtraData: ExtraDataTypes>: CollectionViewCell, UIConfigProvider {
    // MARK: Properties

    internal class var reuseId: String { String(describing: self) }

    internal private(set) lazy var commandView = uiConfig
        .messageComposer
        .suggestionsCommandCellView.init()
        .withoutAutoresizingMaskConstraints

    override internal func setUpLayout() {
        super.setUpLayout()

        contentView.embed(commandView)
    }
}

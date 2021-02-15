//
// Copyright © 2021 Stream.io Inc. All rights reserved.
//

import StreamChat
import UIKit

internal typealias ChatMessageComposerMentionCellView = _ChatMessageComposerMentionCellView<NoExtraData>

internal class _ChatMessageComposerMentionCellView<ExtraData: ExtraDataTypes>: View, UIConfigProvider {
    // MARK: Properties

    internal var content: (title: String, subtitle: String, imageURL: URL?, isUserOnline: Bool)? {
        didSet {
            updateContentIfNeeded()
        }
    }

    internal private(set) lazy var avatarView = uiConfig
        .messageComposer
        .mentionAvatarView
        .init()
        .withoutAutoresizingMaskConstraints

    internal private(set) lazy var usernameLabel: UILabel = UILabel().withoutAutoresizingMaskConstraints
    internal private(set) lazy var usernameTagLabel: UILabel = UILabel().withoutAutoresizingMaskConstraints
    internal private(set) lazy var suggestionTypeImageView: UIImageView = UIImageView().withoutAutoresizingMaskConstraints
    private lazy var textStackView: UIStackView = UIStackView().withoutAutoresizingMaskConstraints

    // MARK: - Appearance

    override internal func defaultAppearance() {
        backgroundColor = .clear
        usernameLabel.font = uiConfig.font.headlineBold

        usernameTagLabel.font = uiConfig.font.subheadlineBold
        usernameTagLabel.textColor = uiConfig.colorPalette.subtitleText

        usernameLabel.textColor = uiConfig.colorPalette.text
    }

    override internal func setUpLayout() {
        addSubview(avatarView)
        addSubview(textStackView)
        addSubview(suggestionTypeImageView)

        setupLeftImageViewConstraints()
        setupStack()
        setupSuggestionTypeImageViewConstraints()
    }

    override internal func updateContent() {
        usernameTagLabel.text = content?.subtitle
        usernameLabel.text = content?.title

        if let url = content?.imageURL {
            avatarView.imageView.loadImage(from: url)
        } else {
            avatarView.imageView.image = uiConfig.images.userAvatarPlaceholder1
        }

        suggestionTypeImageView.image = uiConfig.images.messageComposerCommandsMention
    }

    // MARK: Private

    private func setupLeftImageViewConstraints() {
        avatarView.leadingAnchor.pin(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        avatarView.topAnchor.pin(equalTo: layoutMarginsGuide.topAnchor).isActive = true
        avatarView.bottomAnchor.pin(equalTo: layoutMarginsGuide.bottomAnchor).isActive = true
        avatarView.widthAnchor.pin(equalToConstant: 40).isActive = true
        avatarView.heightAnchor.pin(equalTo: avatarView.widthAnchor).isActive = true
    }

    private func setupStack() {
        textStackView.axis = .vertical
        textStackView.distribution = .equalSpacing
        textStackView.alignment = .leading

        textStackView.addArrangedSubview(usernameLabel)
        textStackView.addArrangedSubview(usernameTagLabel)
        textStackView.centerYAnchor.pin(equalTo: avatarView.centerYAnchor).isActive = true
        textStackView.leadingAnchor.pin(
            equalToSystemSpacingAfter: avatarView.trailingAnchor,
            multiplier: 1
        ).isActive = true

        textStackView.trailingAnchor.pin(
            equalTo: suggestionTypeImageView.leadingAnchor
        ).isActive = true
    }

    private func setupSuggestionTypeImageViewConstraints() {
        suggestionTypeImageView.trailingAnchor.pin(equalTo: layoutMarginsGuide.trailingAnchor).isActive = true
        suggestionTypeImageView.centerYAnchor.pin(equalTo: centerYAnchor).isActive = true
    }
}

internal typealias ChatMessageComposerMentionCollectionViewCell = _ChatMessageComposerMentionCollectionViewCell<NoExtraData>

internal class _ChatMessageComposerMentionCollectionViewCell<ExtraData: ExtraDataTypes>: CollectionViewCell, UIConfigProvider {
    // MARK: Properties

    internal class var reuseId: String { String(describing: self) }

    internal private(set) lazy var mentionView = uiConfig
        .messageComposer
        .suggestionsMentionCellView.init()
        .withoutAutoresizingMaskConstraints

    override internal func setUpLayout() {
        super.setUpLayout()
        
        contentView.embed(
            mentionView,
            insets: contentView.directionalLayoutMargins
        )
    }

    override internal func preferredLayoutAttributesFitting(
        _ layoutAttributes: UICollectionViewLayoutAttributes
    ) -> UICollectionViewLayoutAttributes {
        let preferredAttributes = super.preferredLayoutAttributesFitting(layoutAttributes)

        let targetSize = CGSize(
            width: layoutAttributes.frame.width,
            height: UIView.layoutFittingCompressedSize.height
        )

        preferredAttributes.frame.size = contentView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )

        return preferredAttributes
    }
}

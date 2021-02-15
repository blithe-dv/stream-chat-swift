//
// Copyright © 2021 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamChat
import UIKit

internal typealias ChatChannelListCollectionViewCell = _ChatChannelListCollectionViewCell<NoExtraData>

internal class _ChatChannelListCollectionViewCell<ExtraData: ExtraDataTypes>: CollectionViewCell, UIConfigProvider {
    // MARK: - Properties

    internal private(set) lazy var channelView: _ChatChannelListItemView<ExtraData> = uiConfig.channelList.channelListItemView
        .init()

    // MARK: - UICollectionViewCell

    override internal func prepareForReuse() {
        super.prepareForReuse()
        channelView.trailingConstraint?.constant = 0
    }

    override internal var isHighlighted: Bool {
        didSet {
            channelView.backgroundColor = isHighlighted ? channelView.highlightedBackgroundColor : channelView.normalBackgroundColor
        }
    }

    // MARK: Customizable

    override internal func setUpLayout() {
        super.setUpLayout()
        contentView.embed(channelView)
    }

    // MARK: - Layout
    
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

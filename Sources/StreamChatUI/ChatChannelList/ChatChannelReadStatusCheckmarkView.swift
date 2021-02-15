//
// Copyright © 2021 Stream.io Inc. All rights reserved.
//

import StreamChat
import UIKit

internal typealias ChatChannelReadStatusCheckmarkView = _ChatChannelReadStatusCheckmarkView<NoExtraData>

internal class _ChatChannelReadStatusCheckmarkView<ExtraData: ExtraDataTypes>: View, UIConfigProvider {
    internal enum Status {
        case read, unread, empty
    }
    
    // MARK: - Properties
    
    internal var status: Status = .empty {
        didSet {
            updateContentIfNeeded()
        }
    }
    
    // MARK: - Subviews
    
    private lazy var imageView = UIImageView().withoutAutoresizingMaskConstraints
    
    // MARK: - internal

    override internal func tintColorDidChange() {
        super.tintColorDidChange()
        updateContentIfNeeded()
    }
    
    override internal func defaultAppearance() {
        imageView.contentMode = .scaleAspectFit
    }
    
    override internal func setUpLayout() {
        embed(imageView)
        widthAnchor.pin(equalTo: heightAnchor, multiplier: 1).isActive = true
    }
    
    override internal func updateContent() {
        switch status {
        case .empty:
            imageView.image = nil
        case .read:
            imageView.image = uiConfig.images.channelListReadByAll
            imageView.tintColor = tintColor
        case .unread:
            imageView.image = uiConfig.images.channelListSent
            imageView.tintColor = uiConfig.colorPalette.inactiveTint
        }
    }
}

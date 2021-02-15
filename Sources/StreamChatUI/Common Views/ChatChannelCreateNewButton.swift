//
// Copyright © 2021 Stream.io Inc. All rights reserved.
//

import StreamChat
import UIKit

internal class ChatChannelCreateNewButton<ExtraData: ExtraDataTypes>: Button, UIConfigProvider {
    // MARK: - Overrides
    
    override internal func defaultAppearance() {
        defaultIntrinsicContentSize = .init(width: 44, height: 44)
        setImage(uiConfig.images.newChat, for: .normal)
    }

    internal var defaultIntrinsicContentSize: CGSize?
    override internal var intrinsicContentSize: CGSize {
        defaultIntrinsicContentSize ?? super.intrinsicContentSize
    }
}

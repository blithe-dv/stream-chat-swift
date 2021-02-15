//
// Copyright © 2021 Stream.io Inc. All rights reserved.
//

import StreamChat
import UIKit

internal typealias ChatMessageErrorIndicator = _ChatMessageErrorIndicator<NoExtraData>

internal class _ChatMessageErrorIndicator<ExtraData: ExtraDataTypes>: Button, UIConfigProvider {
    override internal func defaultAppearance() {
        super.defaultAppearance()

        setImage(uiConfig.images.messageListErrorIndicator, for: .normal)
        tintColor = uiConfig.colorPalette.alert
    }
}

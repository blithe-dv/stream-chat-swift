//
// Copyright © 2021 Stream.io Inc. All rights reserved.
//

import StreamChat
import UIKit

public typealias ChatChannelListRouter = _ChatChannelListRouter<NoExtraData>

open class _ChatChannelListRouter<ExtraData: ExtraDataTypes>: ChatRouter<_ChatChannelListVC<ExtraData>> {
    open func openCurrentUserProfile(for currentUser: _CurrentChatUser<ExtraData.User>) {
        debugPrint(currentUser)
    }
    
    open func openChat(for channel: _ChatChannel<ExtraData>) {
        guard let controller = rootViewController?.controller.client.channelController(for: channel.cid) else {
            log.error("Can't push chat detail, the root view controller is `nil`.")
            return
        }

        guard let navController = navigationController else {
            log.error("Can't push chat detail, no navigation controller available")
            return
        }

        let vc = _ChatChannelVC<ExtraData>()
        vc.channelController = controller

        navController.show(vc, sender: self)
    }
    
    open func openCreateNewChannel() {
        debugPrint("internalCreateNewChannel")
    }
}

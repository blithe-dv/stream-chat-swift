//
// Copyright © 2021 Stream.io Inc. All rights reserved.
//

import UIKit.UICollectionViewLayout

internal extension _UIConfig {
    struct ChannelListUI {
        internal var channelCollectionView: ChatChannelListCollectionView.Type = ChatChannelListCollectionView.self
        internal var channelCollectionLayout: UICollectionViewLayout.Type = ChatChannelListCollectionViewLayout.self
        internal var channelListSwipeableItemView: _ChatChannelSwipeableListItemView<ExtraData>.Type =
            _ChatChannelSwipeableListItemView<ExtraData>.self
        internal var channelListItemView: _ChatChannelListItemView<ExtraData>.Type = _ChatChannelListItemView<ExtraData>.self
        internal var channelViewCell: _ChatChannelListCollectionViewCell<ExtraData>.Type =
            _ChatChannelListCollectionViewCell<ExtraData>.self
        internal var newChannelButton: ChatChannelCreateNewButton<ExtraData>.Type = ChatChannelCreateNewButton<ExtraData>.self
        internal var channelNamer: ChatChannelNamer.Type = ChatChannelNamer.self
        internal var channelListItemSubviews = ChannelListItemSubviews()
    }
    
    struct ChannelListItemSubviews {
        internal var avatarView: _ChatChannelAvatarView<ExtraData>.Type = _ChatChannelAvatarView.self
        internal var unreadCountView: _ChatChannelUnreadCountView<ExtraData>.Type = _ChatChannelUnreadCountView<ExtraData>.self
        internal var readStatusView: _ChatChannelReadStatusCheckmarkView<ExtraData>.Type =
            _ChatChannelReadStatusCheckmarkView<ExtraData>.self
        /// A type for the view used as an online activity indicator for avatars.
        internal var onlineIndicator: UIView.Type = _ChatOnlineIndicatorView<ExtraData>.self
    }
}

// MARK: - CurrentUser

internal extension _UIConfig {
    struct CurrentUserUI {
        internal var currentUserViewAvatarView: _CurrentChatUserAvatarView<ExtraData>.Type = _CurrentChatUserAvatarView<ExtraData>
            .self
        internal var avatarView: ChatAvatarView.Type = ChatAvatarView.self
    }
}

//
// Copyright © 2021 Stream.io Inc. All rights reserved.
//

import StreamChat
import UIKit

internal typealias ChatChannelUnreadCountView = _ChatChannelUnreadCountView<NoExtraData>

internal class _ChatChannelUnreadCountView<ExtraData: ExtraDataTypes>: View, UIConfigProvider {
    // MARK: - Properties
    
    internal var inset: CGFloat = 3
    
    override internal var intrinsicContentSize: CGSize {
        let height: CGFloat = max(unreadCountLabel.font.pointSize + inset * 2, frame.height)
        let width = max(unreadCountLabel.intrinsicContentSize.width + inset * 2, height)
        return .init(width: width, height: height)
    }
    
    internal var unreadCount: ChannelUnreadCount = .noUnread {
        didSet {
            updateContent()
        }
    }
    
    // MARK: - Subviews
    
    private lazy var unreadCountLabel = UILabel().withoutAutoresizingMaskConstraints
    
    // MARK: - Init
    
    override internal init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    internal required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        updateContent()
    }
    
    // MARK: - Layout
    
    override internal func invalidateIntrinsicContentSize() {
        super.invalidateIntrinsicContentSize()
        
        unreadCountLabel.invalidateIntrinsicContentSize()
    }
    
    override internal func layoutSubviews() {
        super.layoutSubviews()
        
        invalidateIntrinsicContentSize()
                
        layer.cornerRadius = intrinsicContentSize.height / 2
    }
    
    // MARK: - internal
    
    override internal func defaultAppearance() {
        layer.masksToBounds = true
        backgroundColor = uiConfig.colorPalette.alert

        unreadCountLabel.textColor = uiConfig.colorPalette.staticColorText
        unreadCountLabel.font = uiConfig.font.footnoteBold
        
        unreadCountLabel.adjustsFontForContentSizeCategory = true
        unreadCountLabel.textAlignment = .center
    }

    override internal func setUpLayout() {
        embed(unreadCountLabel, insets: .init(top: inset, leading: inset, bottom: inset, trailing: inset))
        setContentCompressionResistancePriority(.streamRequire, for: .horizontal)
        widthAnchor.pin(greaterThanOrEqualTo: heightAnchor, multiplier: 1).isActive = true
    }
    
    override internal func updateContent() {
        isHidden = unreadCount.mentionedMessages == 0 && unreadCount.messages == 0
        unreadCountLabel.text = String(unreadCount.messages)
    }
}

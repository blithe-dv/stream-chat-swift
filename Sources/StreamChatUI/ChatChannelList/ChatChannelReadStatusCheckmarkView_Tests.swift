//
// Copyright © 2021 Stream.io Inc. All rights reserved.
//

import StreamChat
import StreamChatTestTools
@testable import StreamChatUI
import XCTest

class ChatChannelReadStatusCheckmarkView_Tests: XCTestCase {
    func test_emptyAppearance() {
        let view = ChatChannelReadStatusCheckmarkView().withoutAutoresizingMaskConstraints
        view.addSizeConstraints()
        AssertSnapshot(view, variants: .onlyUserInterfaceStyles)
    }
    
    func test_defaultAppearance_withUnreadStatus() {
        let view = ChatChannelReadStatusCheckmarkView().withoutAutoresizingMaskConstraints
        view.addSizeConstraints()
        view.content = .unread
        AssertSnapshot(view, variants: .onlyUserInterfaceStyles)
    }
    
    func test_defaultAppearance_withReadStatus() {
        let view = ChatChannelReadStatusCheckmarkView().withoutAutoresizingMaskConstraints
        view.addSizeConstraints()
        view.content = .read
        AssertSnapshot(view, variants: .onlyUserInterfaceStyles)
    }
    
    func test_appearanceCustomization_usingUIConfig() {
        var config = UIConfig()
        config.colorPalette.inactiveTint = .green
        config.images.channelListReadByAll = TestImages.yoda.image
        
        let view = ChatChannelReadStatusCheckmarkView().withoutAutoresizingMaskConstraints
        view.addSizeConstraints()
        view.uiConfig = config
        
        view.content = .unread
        AssertSnapshot(view, variants: .onlyUserInterfaceStyles, suffix: "unread")
        
        view.content = .read
        AssertSnapshot(view, variants: .onlyUserInterfaceStyles, suffix: "read")
    }
    
    func test_appearanceCustomization_usingAppearanceHook() {
        class TestView: ChatChannelReadStatusCheckmarkView {}
        TestView.defaultAppearance {
            $0.imageView.contentMode = .bottom
            $0.imageView.backgroundColor = .yellow
            
            $0.imageView.bottomAnchor.constraint(equalTo: $0.bottomAnchor, constant: 2).isActive = true
        }
        
        let view = TestView().withoutAutoresizingMaskConstraints
        
        view.addSizeConstraints()
        
        view.content = .unread
        AssertSnapshot(view, variants: .onlyUserInterfaceStyles)
    }
    
    func test_appearanceCustomization_usingSubclassing() {
        class TestView: ChatChannelReadStatusCheckmarkView {
            override func setUpAppearance() {
                imageView.backgroundColor = .red
                imageView.contentMode = .bottom
            }
            
            override func setUpLayout() {
                super.setUpLayout()
                imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 2).isActive = true
            }
        }
        
        let view = TestView().withoutAutoresizingMaskConstraints
        view.addSizeConstraints()
        view.content = .read
        AssertSnapshot(view, variants: .onlyUserInterfaceStyles)
    }
    
    func test_respectsTintColorChange() {
        let view = ChatChannelReadStatusCheckmarkView().withoutAutoresizingMaskConstraints
        view.addSizeConstraints()
        view.content = .read
        
        view.tintColor = .green
        
        AssertSnapshot(view, variants: .onlyUserInterfaceStyles)
    }
}

private extension ChatChannelReadStatusCheckmarkView {
    func addSizeConstraints() {
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 20),
            widthAnchor.constraint(equalToConstant: 20)
        ])
    }
}

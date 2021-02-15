//
// Copyright © 2021 Stream.io Inc. All rights reserved.
//

import Foundation
import UIKit

internal class ChatChannelListCollectionViewLayout: UICollectionViewFlowLayout {
    // MARK: - Init & Deinit
    
    override internal init() {
        super.init()
        commonInit()
    }
    
    internal required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    // MARK: - Overrides
    
    override internal func prepare() {
        super.prepare()
        
        estimatedItemSize = .init(
            width: collectionView?.bounds.width ?? 0,
            height: 64
        )
    }
    
    // MARK: - Private
    
    private func commonInit() {
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        
        subscribeToNotifications()
    }
    
    private func subscribeToNotifications() {
        let center = NotificationCenter.default
        
        center.addObserver(
            self,
            selector: #selector(didChangeContentSizeCategory),
            name: UIContentSizeCategory.didChangeNotification,
            object: nil
        )
    }
    
    @objc private func didChangeContentSizeCategory(_ notification: Notification) {
        invalidateLayout()
    }
}

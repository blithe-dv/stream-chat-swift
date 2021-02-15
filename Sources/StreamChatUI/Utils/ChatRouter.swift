//
// Copyright © 2021 Stream.io Inc. All rights reserved.
//

import UIKit

open class ChatRouter<Controller: UIViewController> {
    open weak var rootViewController: Controller?
    
    open var navigationController: UINavigationController? {
        rootViewController?.navigationController
    }
    
    public required init(rootViewController: Controller) {
        self.rootViewController = rootViewController
    }
}

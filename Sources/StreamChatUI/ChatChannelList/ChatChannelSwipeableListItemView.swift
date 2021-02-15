//
// Copyright © 2021 Stream.io Inc. All rights reserved.
//

import StreamChat
import UIKit

internal typealias ChatChannelSwipeableListItemView = _ChatChannelSwipeableListItemView<NoExtraData>

internal class _ChatChannelSwipeableListItemView<ExtraData: ExtraDataTypes>: View, UIConfigProvider, UIGestureRecognizerDelegate {
    // MARK: - Properties

    private var startedValue: CGFloat = 0
    private var maxActionWidth: CGFloat = 0
    internal var trailingConstraint: NSLayoutConstraint?
    
    internal var separatorHeight: CGFloat = 0.4

    internal var deleteButtonAction: (() -> Void)?

    /// Main Content view to which you should always embed your cell content.
    internal private(set) lazy var cellContentView: UIView = UIView().withoutAutoresizingMaskConstraints
    internal private(set) lazy var deleteButton: UIButton = UIButton().withoutAutoresizingMaskConstraints
    internal private(set) lazy var actionButtonStack: UIStackView = UIStackView().withoutAutoresizingMaskConstraints
    internal private(set) lazy var bottomSeparatorView: UIView = UIView().withoutAutoresizingMaskConstraints

    // MARK: - View

    override internal func setUpLayout() {
        super.setUpLayout()
        addSubview(cellContentView)
        cellContentView.pin(anchors: [.top, .bottom, .width], to: self)
        addSubview(actionButtonStack)
        actionButtonStack.addArrangedSubview(deleteButton)

        actionButtonStack.trailingAnchor.pin(greaterThanOrEqualTo: trailingAnchor).isActive = true

        actionButtonStack.pin(anchors: [.top, .bottom], to: self)

        actionButtonStack.axis = .horizontal
        actionButtonStack.alignment = .fill

        deleteButton.widthAnchor.pin(equalTo: deleteButton.heightAnchor).almostRequired.isActive = true
        deleteButton.heightAnchor.pin(equalTo: heightAnchor).isActive = true

        cellContentView.trailingAnchor.pin(equalTo: actionButtonStack.leadingAnchor).isActive = true
        trailingConstraint = trailingAnchor.pin(equalTo: cellContentView.trailingAnchor)
        trailingConstraint?.isActive = true
        
        addSubview(bottomSeparatorView)
        bottomSeparatorView.heightAnchor.pin(equalToConstant: separatorHeight).isActive = true
        bottomSeparatorView.pin(anchors: [.bottom, .leading, .trailing], to: self)
    }

    override internal func setUp() {
        super.setUp()

        deleteButton.addTarget(self, action: #selector(didTapDelete), for: .touchUpInside)

        let pan = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
        pan.delegate = self
        addGestureRecognizer(pan)
    }

    override internal func defaultAppearance() {
        super.defaultAppearance()

        bottomSeparatorView.backgroundColor = uiConfig.colorPalette.border

        deleteButton.setImage(uiConfig.images.messageActionDelete, for: .normal)

        deleteButton.backgroundColor = uiConfig.colorPalette.background1
        deleteButton.tintColor = uiConfig.colorPalette.alert
    }

    // MARK: - Button actions

    @objc func didTapDelete() {
        deleteButtonAction?()
    }

    // MARK: Gesture recognizer

    override internal func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let recognizer = gestureRecognizer as? UIPanGestureRecognizer else {
            return super.gestureRecognizerShouldBegin(gestureRecognizer)
        }

        // Fetch the swipe movement in the cell view. If horizontal swipe is detected,
        // we allow the gestureRecognizer to continue the swipe, if it's horizontal,
        // we deny it so we can continue on showing the cell option menu.
        //
        // *This practically means on panning the cell we don't accidentally scroll the list
        let translation = recognizer.translation(in: self)

        return abs(translation.x) > abs(translation.y)
    }

    internal func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        // Default implementation of this function returns false, that means that gestureRecognizer
        // is not required to resign and we can have 2 simultaneous recognizers running at the same time.
        // by implementing this and set return to true, we deny any other touches to interfere.
        //
        // *This practically means on scrolling the list we don't accidentally reveal the cell actions.
        true
    }
    
    internal func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        true
    }

    @objc func didPan(_ gesture: UIPanGestureRecognizer) {
        if gesture.state == .began {
            startedValue = trailingConstraint?.constant ?? 0
            maxActionWidth = actionButtonStack.frame.width
        }

        let translation = gesture.translation(in: self)
        let value: CGFloat
        if translation.x < 0 {
            value = startedValue - translation.x
        } else {
            value = max(0, startedValue - translation.x)
        }

        if gesture.state == .cancelled || gesture.state == .failed {
            trailingConstraint?.constant = 0
            return
        }
        if gesture.state == .ended {
            if value > maxActionWidth / 2 {
                trailingConstraint?.constant = maxActionWidth
            } else {
                trailingConstraint?.constant = 0
            }

            Animate { self.layoutIfNeeded() }
            return
        }
        trailingConstraint?.constant = value
    }
}

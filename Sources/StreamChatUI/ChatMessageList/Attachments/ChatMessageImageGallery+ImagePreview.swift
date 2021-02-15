//
// Copyright © 2021 Stream.io Inc. All rights reserved.
//

import Nuke
import StreamChat
import UIKit

extension _ChatMessageImageGallery {
    internal class ImagePreview: View, UIConfigProvider {
        internal var content: _ChatMessageAttachmentListViewData<ExtraData>.ItemData? {
            didSet { updateContentIfNeeded() }
        }
        
        private var imageTask: ImageTask? {
            didSet { oldValue?.cancel() }
        }

        // MARK: - Subviews

        internal private(set) lazy var imageView: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.layer.masksToBounds = true
            return imageView.withoutAutoresizingMaskConstraints
        }()

        internal private(set) lazy var loadingIndicator = uiConfig
            .messageList
            .messageContentSubviews
            .attachmentSubviews
            .loadingIndicator
            .init()
            .withoutAutoresizingMaskConstraints

        internal private(set) lazy var uploadingOverlay = uiConfig
            .messageList
            .messageContentSubviews
            .attachmentSubviews
            .imageGalleryItemUploadingOverlay
            .init()
            .withoutAutoresizingMaskConstraints

        // MARK: - Overrides

        override internal func defaultAppearance() {
            imageView.backgroundColor = uiConfig.colorPalette.background1
        }

        override internal func setUp() {
            super.setUp()
            
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapOnAttachment(_:)))
            addGestureRecognizer(tapRecognizer)
        }

        override internal func setUpLayout() {
            embed(imageView)
            embed(uploadingOverlay)

            addSubview(loadingIndicator)
            loadingIndicator.centerYAnchor.pin(equalTo: centerYAnchor).isActive = true
            loadingIndicator.centerXAnchor.pin(equalTo: centerXAnchor).isActive = true
        }

        override internal func updateContent() {
            let attachment = content?.attachment

            if let url = attachment?.localURL ?? attachment?.imagePreviewURL ?? attachment?.imageURL {
                loadingIndicator.isVisible = true
                imageTask = loadImage(with: url, options: .shared, into: imageView, completion: { [weak self] _ in
                    self?.loadingIndicator.isVisible = false
                    self?.imageTask = nil
                })
            } else {
                loadingIndicator.isVisible = false
                imageView.image = nil
                imageTask = nil
            }

            uploadingOverlay.content = content
            uploadingOverlay.isVisible = attachment?.localState != nil
        }

        // MARK: - Actions

        @objc internal func didTapOnAttachment(_ recognizer: UITapGestureRecognizer) {
            content?.didTapOnAttachment()
        }

        // MARK: - Init & Deinit

        deinit {
            imageTask?.cancel()
        }
    }
}

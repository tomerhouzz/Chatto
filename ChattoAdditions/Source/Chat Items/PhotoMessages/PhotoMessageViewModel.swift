/*
 The MIT License (MIT)

 Copyright (c) 2015-present Badoo Trading Limited.

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
*/

import UIKit
import HouzzCore

public enum TransferDirection {
    case upload
    case download
}

public enum TransferStatus {
    case idle
    case transfering
    case failed
    case success
}

public protocol PhotoMessageViewModelProtocol: DecoratedMessageViewModelProtocol {
    var transferDirection: Observable<TransferDirection> { get set }
    var transferProgress: Observable<Double> { get  set } // in [0,1]
    var transferStatus: Observable<TransferStatus> { get set }
    var imageUrl: Observable<URL?> { get set }
    var imageSize: CGSize { get }
}

open class PhotoMessageViewModel: PhotoMessageViewModelProtocol {
    public var photoMessage: SocketMessage
    public var transferStatus: Observable<TransferStatus> = Observable(.idle)
    public var transferProgress: Observable<Double> = Observable(0)
    public var transferDirection: Observable<TransferDirection> = Observable(.download)
    public var imageUrl: Observable<URL?>
    open var imageSize: CGSize {
        return CGSize(width: 210, height: 210)
    }
    public let messageViewModel: MessageViewModelProtocol
    open var showsFailedIcon: Bool {
        return self.messageViewModel.showsFailedIcon || self.transferStatus.value == .failed
    }

    public init(photoMessage: SocketMessage, messageViewModel: MessageViewModelProtocol) {
        self.photoMessage = photoMessage
        self.imageUrl = Observable(photoMessage.url)
        self.messageViewModel = messageViewModel
    }

    open func willBeShown() {
        // Need to declare empty. Otherwise subclass code won't execute (as of Xcode 7.2)
    }

    open func wasHidden() {
        // Need to declare empty. Otherwise subclass code won't execute (as of Xcode 7.2)
    }
}

open class PhotoMessageViewModelDefaultBuilder: ViewModelBuilderProtocol {
    public init() {}

    let messageViewModelBuilder = MessageViewModelDefaultBuilder()

    open func createViewModel(_ model: SocketMessage) -> PhotoMessageViewModel {
        let messageViewModel = self.messageViewModelBuilder.createMessageViewModel(model)
        let photoMessageViewModel = PhotoMessageViewModel(photoMessage: model, messageViewModel: messageViewModel)
        return photoMessageViewModel
    }

    open func canCreateViewModel(fromModel model: Any) -> Bool {
        return model is SocketMessage
    }
}

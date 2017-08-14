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

import Foundation
import HouzzCore

public protocol TextMessageModelProtocol: DecoratedMessageModelProtocol {
    var text: String { get }
}

open class TextMessageModel<MessageModelT: MessageModelProtocol>: TextMessageModelProtocol {
    
    public var messageModel: MessageModelProtocol {
        return self._messageModel
    }
    public let _messageModel: MessageModelT // Can't make messasgeModel: MessageModelT: https://gist.github.com/diegosanchezr/5a66c7af862e1117b556
    public let text: String
    public init(messageModel: MessageModelT, text: String) {
        self._messageModel = messageModel
        self.text = text
    }
    
    public var socketMessage: SocketMessage?
    
    public var status: MessageStatus {
        get {
            return _messageModel.status
        }
        set {
            _messageModel.status = newValue
        }
    }
    
    open var data: [String: Any] {
        if let socketMessage = socketMessage {
            return ["_id": socketMessage.identifier, "User": ["_id": socketMessage.senderId, "SenderUrl": socketMessage.senderUrl!.absoluteString], "CreatedAt": socketMessage.createdAt.timeIntervalSince1970, "Text": socketMessage.text!, "Type": socketMessage.type]
        } else {
            let profileImage = AppDefaults.shared.user!.profileImage!.absoluteString
            return ["User": ["_id": senderId, "SenderUrl": profileImage], "CreatedAt": date.timeIntervalSince1970, "Text": text, "Type": type]
        }
    }
}

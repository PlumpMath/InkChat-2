//
//  Message.swift
//  InkChat
//
//  Created by iOS Dev Log on 2017/5/30.
//  Copyright © 2017年 iOSDevLog. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import Firebase

class Message: JSQMessage {
    var timestamp: NSNumber?
    var toId: String?
    var imageUrl: String?
    var videoUrl: String?
    
    func from(dictionary: [String: Any]) {
        self.text = dictionary["text"] as? String
        self.toId = dictionary["toId"] as? String
        self.timestamp = dictionary["timestamp"] as? NSNumber
        self.imageUrl = dictionary["imageUrl"] as? String
        self.videoUrl = dictionary["videoUrl"] as? String
        self.senderId = dictionary["senderId"] as? String
    }
    
    func chatPartnerId() -> String? {
        return senderId == Auth.auth().currentUser?.uid ? toId : senderId
    }
}

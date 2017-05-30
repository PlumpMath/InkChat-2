//
//  ChatViewController.swift
//  InkChat
//
//  Created by iOS Dev Log on 2017/5/30.
//  Copyright © 2017年 iOSDevLog. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import MobileCoreServices
import AVKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
import SDWebImage

class ChatViewController: JSQMessagesViewController {
    
    var messages = [JSQMessage]()
    var avatarDict = [String: JSQMessagesAvatarImage]()
    
    var user: User? {
        didSet {
            navigationItem.title = user?.name
            observeMessages()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let currentUser = Auth.auth().currentUser {
            self.senderId = currentUser.uid
            self.senderDisplayName = ad.user?.name
        }
    }
    
    func observeMessages() {
        
        guard let uid = Auth.auth().currentUser?.uid, let toId = user?.id else {
            return
        }
        
        
        let userMessagesRef = Database.database().reference().child("user-messages").child(uid).child(toId)
        userMessagesRef.observe(.childAdded, with: { (snapshot) in
            
            let messageId = snapshot.key
            let messagesRef = Database.database().reference().child("messages").child(messageId)
            messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let dictionary = snapshot.value as? [String: AnyObject] else {
                    return
                }
                
                let message = Message(senderId: "", senderDisplayName: "", date: Date(), text: "")
                message?.from(dictionary: dictionary)
                
                self.messages.append(message!)
                self.observeUsers((message?.chatPartnerId())!)
                DispatchQueue.main.async(execute: {
                    self.collectionView?.reloadData()
                    //scroll to the last index
                    let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
                    self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
                })
                
            }, withCancel: nil)
            
        }, withCancel: nil)
    }
    
    func observeUsers(_ id: String) {
        Database.database().reference().child("users").child(id).child("credentials").observe(.value, with: {
            snapshot in
            if let dict = snapshot.value as? [String: AnyObject] {
                let avatarUrl = dict["profileImageUrl"] as! String
                
                self.setupAvatar(avatarUrl, messageId: id)
            }
        })
    }
    
    func setupAvatar(_ url: String, messageId: String) {
        if url != "" {
            let fileUrl = URL(string: url)
            let data = try? Data(contentsOf: fileUrl!)
            let image = UIImage(data: data!)
            let userImg = JSQMessagesAvatarImageFactory.avatarImage(with: image, diameter: 30)
            self.avatarDict[messageId] = userImg
            DispatchQueue.main.async{
                self.collectionView.reloadData()
            }
        } else {
            avatarDict[messageId] = JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named: "profileImage"), diameter: 30)
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item]
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        if message.senderId == self.senderId {
            return bubbleFactory!.outgoingMessagesBubbleImage(with: .black)
        } else {
            return bubbleFactory!.incomingMessagesBubbleImage(with: .blue)
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        let message = messages[indexPath.item]
        
        return avatarDict[message.senderId]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("number of item:\(messages.count)")
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        
        return cell
    }
    
    fileprivate func sendMessageWithProperties(_ properties: [String: AnyObject]) {
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let toId = user!.id!
        let senderId = Auth.auth().currentUser!.uid
        let timestamp = Int(Date().timeIntervalSince1970)
        
        var values: [String: AnyObject] = ["toId": toId as AnyObject, "senderId": senderId as AnyObject, "timestamp": timestamp as AnyObject]
        
        //append properties dictionary onto values somehow??
        //key $0, value $1
        properties.forEach({values[$0] = $1})
        
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error!)
                return
            }
            
            let userMessagesRef = Database.database().reference().child("user-messages").child(senderId).child(toId)
            
            let messageId = childRef.key
            userMessagesRef.updateChildValues([messageId: 1])
            
            let recipientUserMessagesRef = Database.database().reference().child("user-messages").child(toId).child(senderId)
            recipientUserMessagesRef.updateChildValues([messageId: 1])
        }
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        let properties = ["text": text]
        self.sendMessageWithProperties(properties as [String : AnyObject])
        
        self.finishSendingMessage()
    }
}

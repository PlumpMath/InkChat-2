//
//  User.swift
//  InkChat
//
//  Created by iOS Dev Log on 2017/5/28.
//  Copyright © 2017年 iOSDevLog. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import PKHUD

class User: NSObject {
    var id: String?
    var name: String?
    var email: String?
    var city: String?
    var profileImageUrl: String?
    var type: String?
    var profileImage: UIImage?
    
    init(dictionary: [String: AnyObject]) {
        self.id = dictionary["id"] as? String
        self.type = dictionary["type"] as? String
        self.name = dictionary["name"] as? String
        self.email = dictionary["email"] as? String
        self.city = dictionary["city"] as? String
        self.profileImageUrl = dictionary["profileImageUrl"] as? String
    }
    
    //MARK: Inits
    init(id: String, name: String, email: String, city: String,profileImageUrl: String, profileImage: UIImage, type: String) {
        self.name = name
        self.email = email
        self.id = id
        self.city = city
        self.type = type
        self.profileImageUrl = profileImageUrl
        self.profileImage = profileImage
    }

    class func signUpUser(username: String, email: String, password: String, city: String, image: UIImage, type: String = "artist", completion: @escaping (Bool) -> Swift.Void) {
        let existUser = ad.users.contains { (user) -> Bool in
            user.name == username
        }
        
        guard existUser == false else {
            HUD.flash(.labeledProgress(title: "Error", subtitle: "username exist, try another"), delay: 2.0)
            completion(false)
            return
        }

        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                print(error!)
                HUD.flash(.labeledProgress(title: "Error", subtitle: error?.localizedDescription), delay: 2.0)
                completion(false)
                return
            }
            
            guard let uid = user?.uid else {
                completion(false)
                return
            }
            //successfully authenticated user
            let imageName = UUID().uuidString
            let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).jpg")
            
            if let uploadData = UIImageJPEGRepresentation(image, 0.1) {
                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        print(error!)
                        HUD.flash(.labeledProgress(title: "Error", subtitle: error?.localizedDescription), delay: 2.0)
                        return
                    }
                    
                    if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                        let values = ["name": username, "email": email, "profileImageUrl": profileImageUrl, "city": city, "type": type]
                        let ref = Database.database().reference()
                        let usersReference = ref.child("users").child(uid).child("credentials")
                        
                        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                            if err != nil {
                                print(err!)
                                HUD.flash(.labeledProgress(title: "Error", subtitle: err?.localizedDescription), delay: 2.0)
                                return
                            }
                            
                            ad.user = User(dictionary: values as [String : AnyObject])
                            UserDefaults.standard.set(values, forKey: "userInformation")
                            UserDefaults.standard.synchronize()
                            
                            completion(true)
                        })
                    }
                })
            }
        })
    }
    
    class func loginUser(userName: String, password: String, completion: @escaping (Bool) -> Swift.Void) {
        if let fileUser = ad.users.filter({ (user) -> Bool in
            user.name == userName
        }).first {
            let email = fileUser.email
            Auth.auth().signIn(withEmail: email!, password: password, completion: { (userInfo, error) in
                if error == nil {
                    self.info(forUserID: (userInfo?.uid)!, completion: { (user) in
                        ad.user = user
                    })
                    
                    completion(true)
                } else {
                    HUD.flash(.labeledProgress(title: "Error", subtitle: error?.localizedDescription), delay: 2.0)
                    completion(false)
                }
            })
        } else {
            HUD.flash(.labeledProgress(title: "Error", subtitle: "user is not exist"), delay: 2.0)
           completion(false)
        }
        
    }
   
    class func loginUser(email: String, password: String, completion: @escaping (Bool) -> Swift.Void) {
        Auth.auth().signIn(withEmail: email, password: password, completion: { (userInfo, error) in
            if error == nil {
                let userId = userInfo?.uid
                if let id = Auth.auth().currentUser?.uid {
                    self.info(forUserID: id, completion: { (user) in
                       ad.user = user
                    })
                }
                completion(true)
            } else {
                completion(false)
            }
        })
    }
    
    
    class func logOutUser(completion: @escaping (Bool) -> Swift.Void) {
        do {
            try Auth.auth().signOut()
            UserDefaults.standard.removeObject(forKey: "userInformation")
            completion(true)
        } catch _ {
            completion(false)
        }
    }
    
    class func info(forUserID: String, completion: @escaping (User) -> Swift.Void) {
        Database.database().reference().child("users").child(forUserID).child("credentials").observeSingleEvent(of: .value, with: { (snapshot) in
            if let data = snapshot.value as? [String: String] {
                let name = data["name"]!
                let email = data["email"]!
                let type = data["type"]!
                let city = data["city"]!
                let profileImageUrl = data["profileImageUrl"]!
                let link = URL.init(string: profileImageUrl)
                URLSession.shared.dataTask(with: link!, completionHandler: { (data, response, error) in
                    if error == nil {
                        let profileImage = UIImage(data: data!)
                        let user = User(id: forUserID, name: name, email: email, city: city, profileImageUrl: profileImageUrl, profileImage: profileImage!, type: type)
                        completion(user)
                    }
                }).resume()
            }
        })
    }
    
    class func downloadAllUsers(completion: @escaping (User) -> Swift.Void) {
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            let id = snapshot.key
            let data = snapshot.value as! [String: Any]
            let credentials = data["credentials"] as! [String: String]
            let name = credentials["name"]!
            let email = credentials["email"]!
            let city = credentials["city"]!
            let type = credentials["type"]!
            let profileImageUrl = credentials["profileImageUrl"]!
            let link = URL.init(string: profileImageUrl)
            URLSession.shared.dataTask(with: link!, completionHandler: { (data, response, error) in
                if error == nil {
                    let profileImage = UIImage(data: data!)
                    let user = User(id: id, name: name, email: email, city: city, profileImageUrl: profileImageUrl, profileImage: profileImage!, type: type)
                    completion(user)
                }
            }).resume()
        })
    }
    
    class func downloadAllUsers(exceptID: String, completion: @escaping (User) -> Swift.Void) {
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            let id = snapshot.key
            let data = snapshot.value as! [String: Any]
            let credentials = data["credentials"] as! [String: String]
            if id != exceptID {
                let name = credentials["name"]!
                let email = credentials["email"]!
                let type = credentials["type"]!
                let city = credentials["city"]!
                let profileImageUrl = credentials["profileImageUrl"]!
                let link = URL.init(string: profileImageUrl)
                URLSession.shared.dataTask(with: link!, completionHandler: { (data, response, error) in
                    if error == nil {
                        let profileImage = UIImage(data: data!)
                        let user = User(id: id, name: name, email: email, city: city, profileImageUrl: profileImageUrl, profileImage: profileImage!, type: type)
                        completion(user)
                    }
                }).resume()
            }
        })
    }
    
    class func checkUserVerification(completion: @escaping (Bool) -> Swift.Void) {
        Auth.auth().currentUser?.reload(completion: { (_) in
            let status = (Auth.auth().currentUser?.isEmailVerified)!
            completion(status)
        })
    }
}

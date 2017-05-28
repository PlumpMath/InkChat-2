//
//  Product.swift
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

class Product {
    var userId: String?
    var productImageUrl: String?
    var name: String?
    var city: String?
    var id: String?
    
    
    init(dictionary: [String: AnyObject]) {
        self.userId = dictionary["userId"] as? String
        self.productImageUrl = dictionary["productImageUrl"] as? String
        self.name = dictionary["name"] as? String
        self.city = dictionary["city"] as? String
        self.id = dictionary["id"] as? String
    }
    
    class func updateProduct(image: UIImage, completion: @escaping (Product) -> Swift.Void) {
        let imageName = UUID().uuidString
        let storageRef = Storage.storage().reference().child("product_images").child("\(imageName).jpg")
        
        if let uploadData = UIImageJPEGRepresentation(image, 0.1) {
            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    print(error!)
                    HUD.flash(.labeledProgress(title: "Error", subtitle: error?.localizedDescription), delay: 2.0)
                    return
                }
                
                if let productImageUrl = metadata?.downloadURL()?.absoluteString {
                    let user = ad.user!
                    let values = ["userId": user.id!,"name": user.name!, "productImageUrl": productImageUrl, "city": user.city!]
                    let ref = Database.database().reference()
                    let productId = UUID().uuidString
                    let usersReference = ref.child("products").child(productId)
                    
                    usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                        if err != nil {
                            print(err!)
                            HUD.flash(.labeledProgress(title: "Error", subtitle: err?.localizedDescription), delay: 2.0)
                            return
                        }
                       
                        let product = Product(dictionary: values as [String : AnyObject])
                        
                        completion(product)
                    })
                }
            })
        }
    }
    
    class func downloadAllProduct(completion: @escaping (Product) -> Swift.Void) {
        Database.database().reference().child("products").observe(.childAdded, with: { (snapshot) in
            let id = snapshot.key
            let data = snapshot.value as! [String: String]
            let productImageUrl = data["productImageUrl"]!
            let name = data["name"]!
            let city = data["city"]!
            let values = ["id": id, "name": name, "city": city, "productImageUrl": productImageUrl]
            let product = Product(dictionary: values as [String : AnyObject])
            completion(product)
        })
    }
    
    class func download(exceptID: String, completion: @escaping (Product) -> Swift.Void) {
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            let id = snapshot.key
            let data = snapshot.value as! [String: Any]
            let credentials = data["credentials"] as! [String: String]
            if id != exceptID {
                let name = credentials["name"]!
                let userId = credentials["userId"]!
                let city = credentials["city"]!
                let productImageUrl = credentials["productImageUrl"]!
                let link = URL.init(string: productImageUrl)
                URLSession.shared.dataTask(with: link!, completionHandler: { (data, response, error) in
                    if error == nil {
                        let values = ["userId": userId,
                                      "name": name,
                                      "productImageUrl": productImageUrl,
                                      "city": city,
                                      "id": id]
                        
                        let product = Product(dictionary: values as [String : AnyObject])
                        
                        completion(product)
                    }
                }).resume()
            }
        })
    }
}

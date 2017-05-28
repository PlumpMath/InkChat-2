//
//  SignUpViewController.swift
//  InkChat
//
//  Created by iOS Dev Log on 2017/5/28.
//  Copyright © 2017年 iOSDevLog. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var chooseAvatarImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chooseAvatarImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(chooseAvatar)))
        chooseAvatarImageView.isUserInteractionEnabled = true
    }
    
    func chooseAvatar() {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func signUp(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = usernameTextField.text, let city = cityTextField.text else {
            print("Form is not valid")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                print(error!)
                return
            }
            
            guard let uid = user?.uid else {
                return
            }
            
            //successfully authenticated user
            let imageName = UUID().uuidString
            let storageRef = Storage.storage().reference().child("avatar_images").child("\(imageName).jpg")
            
            if let profileImage = self.avatarImageView.image, let uploadData = UIImageJPEGRepresentation(profileImage, 0.1) {
                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    
                    if let avatarImageUrl = metadata?.downloadURL()?.absoluteString {
                        let values = ["name": name, "email": email, "avatarImageUrl": avatarImageUrl, "city": city]
                        self.registerUserIntoDatabaseWithUID(uid, values: values as [String : AnyObject])
                    }
                })
            }
        })
    }
    
    fileprivate func registerUserIntoDatabaseWithUID(_ uid: String, values: [String: AnyObject]) {
        let ref = Database.database().reference()
        let usersReference = ref.child("users").child(uid)
        
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if err != nil {
                print(err!)
                return
            }
            
            ad.user = User(dictionary: values)
            
            self.performSegue(withIdentifier: "StyleViewControllerSegue", sender: nil)
        })
    }
}


extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            avatarImageView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }
}

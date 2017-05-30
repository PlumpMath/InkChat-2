//
//  SignUpViewController.swift
//  InkChat
//
//  Created by iOS Dev Log on 2017/5/28.
//  Copyright © 2017年 iOSDevLog. All rights reserved.
//

import UIKit
import Firebase
import PKHUD

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var chooseAvatarImageView: UIImageView!
    
    var userType: String = "artist"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chooseAvatarImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(chooseAvatar)))
        chooseAvatarImageView.isUserInteractionEnabled = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.view.endEditing(true)
    }
    
    func chooseAvatar() {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func signUp(_ sender: UIButton) {
        HUD.show(.progress)
        guard let email = emailTextField.text, let password = passwordTextField.text, let username = usernameTextField.text, let city = cityTextField.text else {
            print("Form is not valid")
            HUD.flash(.labeledProgress(title: "Error", subtitle: "Form is not valid"), delay: 2.0)
            return
        }
        
        guard !username.isEmpty else {
            HUD.flash(.labeledProgress(title: "Error", subtitle: "username is not valid"), delay: 2.0)
            return
        }
        
        guard !password.isEmpty else {
            HUD.flash(.labeledProgress(title: "Error", subtitle: "password is not valid"), delay: 2.0)
            return
        }
        
        guard !email.isEmpty else {
            HUD.flash(.labeledProgress(title: "Error", subtitle: "email is not valid"), delay: 2.0)
            return
        }
        
        guard !city.isEmpty else {
            HUD.flash(.labeledProgress(title: "Error", subtitle: "city is not valid"), delay: 2.0)
            return
        }
        
        User.signUpUser(username: username, email: email, password: password, city: city, image: avatarImageView.image!, type: self.userType) { (status) in
            DispatchQueue.main.async {
                HUD.hide(animated: true)
                if status {
                    self.performSegue(withIdentifier: "StyleViewControllerSegue", sender: nil)
                } else {
//                    HUD.flash(.error, delay: 1.0)
                }
            }
        }
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

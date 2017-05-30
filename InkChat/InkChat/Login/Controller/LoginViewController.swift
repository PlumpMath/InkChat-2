//
//  LoginViewController.swift
//  InkChat
//
//  Created by iOS Dev Log on 2017/5/26.
//  Copyright © 2017年 iOSDevLog. All rights reserved.
//

import UIKit
import Firebase
import PKHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.barTintColor = nil
        self.navigationController?.navigationBar.backgroundColor = nil
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    }
    
    @IBAction func login(_ sender: UIButton) {
        HUD.show(.progress)
        guard let username = usernameTextField.text, let password = passwordTextField.text else {
            print("Form is not valid")
            HUD.flash(.labeledProgress(title: "Error", subtitle: "Form is not valid"), delay: 2.0)
            return
        }
        
        User.loginUser(userName: username, password: password) { (status) in
            HUD.hide(animated: true)
            if status {
                self.dismiss(animated: true, completion: nil)
            } else {
                print("Log in error")
            }
        }
    }

}

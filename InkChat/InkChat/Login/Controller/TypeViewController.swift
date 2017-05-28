//
//  TypeViewController.swift
//  InkChat
//
//  Created by iOS Dev Log on 2017/5/28.
//  Copyright © 2017年 iOSDevLog. All rights reserved.
//

import UIKit

class TypeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signUpUser(_ sender: UIButton) {
        self.performSegue(withIdentifier: "SignUpViewControllerSegue", sender: "user")
    }
    
    @IBAction func artistSignUp(_ sender: UIButton) {
        self.performSegue(withIdentifier: "SignUpViewControllerSegue", sender: "artist")
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SignUpViewControllerSegue" {
            let signUpViewController = segue.destination as? SignUpViewController
            signUpViewController?.userType = sender as! String
        }
    }

}

//
//  UserInfoViewController.swift
//  InkChat
//
//  Created by iOS Dev Log on 2017/5/30.
//  Copyright © 2017年 iOSDevLog. All rights reserved.
//

import UIKit

class UserInfoViewController: UITableViewController {

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = self.user?.name
        emailLabel.text = self.user?.email
        cityLabel.text = self.user?.city
    }
}

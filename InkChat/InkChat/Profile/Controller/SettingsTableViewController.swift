//
//  SettingsTableViewController.swift
//  InkChat
//
//  Created by iOS Dev Log on 2017/5/28.
//  Copyright © 2017年 iOSDevLog. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }
        
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure the cell...
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "section0", for: indexPath)
            
            if indexPath.row == 0 {
                cell.textLabel?.text = "About"
            } else if let type = ad.user?.type {
                cell.textLabel?.text = "Your're \(String(describing: type))"
            }
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "section1", for: indexPath)
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 1 {
            User.logOutUser(completion: { (status) in
                if status {
                   self.dismiss(animated: true, completion: nil)
                }
            })
        } else if (indexPath.section == 0) && (indexPath.row == 1) && ad.user?.type == "artist" {
            self.performSegue(withIdentifier: "PriceSegue", sender: nil)
        }
    }

}

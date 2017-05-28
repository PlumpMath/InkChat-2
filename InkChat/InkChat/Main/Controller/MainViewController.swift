//
//  MainViewController.swift
//  InkChat
//
//  Created by iOS Dev Log on 2017/5/26.
//  Copyright © 2017年 iOSDevLog. All rights reserved.
//

import UIKit
import FirebaseAuth

class MainViewController: SearchControllerBaseViewController {
    var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkIfUserIsLoggedIn()
    }
    
    func checkIfUserIsLoggedIn() {
        let currentUser = Auth.auth().currentUser
        if currentUser?.uid == nil {
            logOut()
        } else {
            ad.user = ad.users.first(where: { (user) -> Bool in
                user.email == currentUser?.email
            })
            Product.downloadAllProduct(completion: { (product) in
                self.allResults.append(product)
                self.visibleResults = self.allResults
                self.tableView.reloadData()
            })
        }
    }
    
    func logOut() {
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        performSegue(withIdentifier: "LoginSegue", sender: nil)
    }
    
    @IBAction func searchButtonClicked(_ sender: UIBarButtonItem) {
        // Create the search results view controller and use it for the `UISearchController`.
        let searchResultsController = storyboard!.instantiateViewController(withIdentifier: SearchResultsViewController.StoryboardConstants.identifier) as! SearchResultsViewController
        
        // Create the search controller and make it perform the results updating.
        searchController = UISearchController(searchResultsController: searchResultsController)
        searchController.searchResultsUpdater = searchResultsController
        searchController.hidesNavigationBarDuringPresentation = false
        
        // Present the view controller.
        present(searchController, animated: true, completion: nil)
    }
    
    @IBAction func swipRight(_ sender: UISwipeGestureRecognizer) {
        if Auth.auth().currentUser?.uid == nil {
            logOut()
        } else {
            performSegue(withIdentifier: "MyProfileSegue", sender: nil)
        }
    }
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MyProfileSegue" {
            let myProfileViewController = ((segue.destination as! UINavigationController).topViewController) as! MyProfileViewController
            myProfileViewController.isMyProfile = true
        }
     }
}

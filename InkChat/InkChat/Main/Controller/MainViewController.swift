//
//  MainViewController.swift
//  InkChat
//
//  Created by iOS Dev Log on 2017/5/26.
//  Copyright © 2017年 iOSDevLog. All rights reserved.
//

import UIKit

class MainViewController: SearchControllerBaseViewController {
    var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

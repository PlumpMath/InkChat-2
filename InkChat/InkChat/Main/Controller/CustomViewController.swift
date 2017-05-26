//
//  CustomViewController.swift
//  InkChat
//
//  Created by iOS Dev Log on 2017/5/26.
//  Copyright © 2017年 iOSDevLog. All rights reserved.
//

import UIKit

class CustomViewController: UIViewController {

    @IBOutlet weak var cameraStackView: UIStackView!
    @IBOutlet weak var shareStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.shareStackView.isHidden = true
        self.cameraStackView.isHidden = false
    }
    
    @IBAction func shareButtonClicked(_ sender: UIBarButtonItem) {
        let isShowShare = self.cameraStackView.isHidden
        self.cameraStackView.isHidden = !isShowShare
        self.shareStackView.isHidden = isShowShare
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

//
//  ProfileViewController.swift
//  InkChat
//
//  Created by iOS Dev Log on 2017/5/26.
//  Copyright © 2017年 iOSDevLog. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var productButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var favariteButton: UIButton!
    @IBOutlet weak var chatButton: UIButton!
    
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.productButtonSelected(self.productButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func productButtonSelected(_ sender: UIButton) {
        self.resetDefaultImage()
        
        self.productButton.setImage(#imageLiteral(resourceName: "product_selected"), for: .normal)
        
        let newController = self.storyboard?.instantiateViewController(withIdentifier: "ShowCollectionViewController")
        
        self.changeViewController(newController: newController!)
    }
    
    
    @IBAction func infoButtonSelected(_ sender: UIButton) {
        self.resetDefaultImage()
        
        self.productButton.setImage(#imageLiteral(resourceName: "product_selected"), for: .normal)
        
        let newController = self.storyboard?.instantiateViewController(withIdentifier: "InfoViewController")
        
        self.changeViewController(newController: newController!)
    }
    
    
    @IBAction func favoriteButtonSelected(_ sender: UIButton) {
        self.resetDefaultImage()
        
        self.productButton.setImage(#imageLiteral(resourceName: "product_selected"), for: .normal)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newController = storyboard.instantiateViewController(withIdentifier: "TattooCollectionViewController")
        
        self.changeViewController(newController: newController)
    }
    
    
    @IBAction func chatButtonSelected(_ sender: UIButton) {
        self.resetDefaultImage()
        
        self.productButton.setImage(#imageLiteral(resourceName: "product_selected"), for: .normal)
    }
    
    func resetDefaultImage() {
        self.productButton.setImage(#imageLiteral(resourceName: "product"), for: .normal)
        self.infoButton.setImage(#imageLiteral(resourceName: "favorite"), for: .normal)
        self.favariteButton.setImage(#imageLiteral(resourceName: "favorite"), for: .normal)
        self.chatButton.setImage(#imageLiteral(resourceName: "chat"), for: .normal)
        self.productButton.setImage(#imageLiteral(resourceName: "chat"), for: .normal)
    }
    
    func changeViewController(newController: UIViewController) {
        let oldController = childViewControllers.last!
        
        oldController.willMove(toParentViewController: nil)
        addChildViewController(newController)
        newController.view.frame = oldController.view.frame
        
        //isAnimating = true
        transition(from: oldController, to: newController, duration: 0.1, options: UIViewAnimationOptions.curveEaseInOut, animations: nil, completion: { (finished) -> Void in
            oldController.removeFromParentViewController()
            newController.didMove(toParentViewController: self)
            //self.isAnimating = false
        })
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

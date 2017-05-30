//
//  ProfileViewController.swift
//  InkChat
//
//  Created by iOS Dev Log on 2017/5/26.
//  Copyright © 2017年 iOSDevLog. All rights reserved.
//

import UIKit
import SDWebImage

class ProfileViewController: UIViewController {

    @IBOutlet weak var productButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var favariteButton: UIButton!
    @IBOutlet weak var chatButton: UIButton!
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    var user: User? {
        didSet {
            self.title = user?.name
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.avatarImageView.sd_setImage(with: URL(string: (user?.profileImageUrl)!), placeholderImage: #imageLiteral(resourceName: "head"))
        self.productButtonSelected(self.productButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func productButtonSelected(_ sender: UIButton) {
        self.resetDefaultImage()
        
        self.productButton.setImage(#imageLiteral(resourceName: "product_selected"), for: .normal)
        
        let newController = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController")
        
        self.changeViewController(newController: newController!)
    }
    
    
    @IBAction func infoButtonSelected(_ sender: UIButton) {
        self.resetDefaultImage()
        
        self.infoButton.setImage(#imageLiteral(resourceName: "info_selected"), for: .normal)
        
        let newController = self.storyboard?.instantiateViewController(withIdentifier: "UserInfoViewController") as? UserInfoViewController
        newController?.user = self.user
        
        self.changeViewController(newController: newController!)
    }
    
    
    @IBAction func favoriteButtonSelected(_ sender: UIButton) {
        self.resetDefaultImage()
        
        self.favariteButton.setImage(#imageLiteral(resourceName: "favorite_selected"), for: .normal)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newController = storyboard.instantiateViewController(withIdentifier: "TattooCollectionViewController")
        
        self.changeViewController(newController: newController)
    }
    
    
    @IBAction func chatButtonSelected(_ sender: UIButton) {
        self.resetDefaultImage()
        
        self.chatButton.setImage(#imageLiteral(resourceName: "chat_selected"), for: .normal)
        
        self.performSegue(withIdentifier: "ChatViewControllerSegue", sender: self.user)
    }
    
    func resetDefaultImage() {
        self.productButton.setImage(#imageLiteral(resourceName: "product"), for: .normal)
        self.infoButton.setImage(#imageLiteral(resourceName: "info"), for: .normal)
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChatViewControllerSegue" {
            let ChatViewController = segue.destination as? ChatViewController
            ChatViewController?.user = self.user
        }
    }
}

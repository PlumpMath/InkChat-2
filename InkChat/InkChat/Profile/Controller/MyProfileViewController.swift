//
//  MyProfileViewController.swift
//  InkChat
//
//  Created by iOS Dev Log on 2017/5/26.
//  Copyright © 2017年 iOSDevLog. All rights reserved.
//

import UIKit
import SDWebImage
import PKHUD

class MyProfileViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var updateStackView: UIStackView!
    
    var screenWidth: CGFloat = 320.0
    var products = [Product]()
    var selectedImage: UIImage!
    
    var isMyProfile: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateStackView.isHidden = true
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        self.collectionView!.register(TattooCollectionViewCell.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        screenWidth = (self.view?.bounds.size.width)!
        self.collectionView?.reloadData()
    }
    
    @IBAction func cameraSelected(_ sender: UIButton) {
        self.updateStackView.isHidden = true
        
        let imagePickerController = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePickerController.sourceType = .camera
        } else {
            HUD.flash(.labeledProgress(title: "Error", subtitle: "This Device is not support Camera"), delay: 2.0)
            return
        }
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func pictureSeleccted(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            imagePickerController.sourceType = .savedPhotosAlbum
        }
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func videoSelected(_ sender: UIButton) {
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
}

// MARK: - UICollectionViewDataSource
extension MyProfileViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var itemCount = products.count
        if isMyProfile {
            itemCount += 1
        }
        return itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as TattooCollectionViewCell
        
        if indexPath.row == products.count {
            cell.tattooImageView.image = #imageLiteral(resourceName: "add")
        } else {
            let product = products[indexPath.row]
            cell.tattooImageView.sd_setImage(with: URL(string: product.productImageUrl!), placeholderImage: #imageLiteral(resourceName: "show_1"))
        }

        
        return cell
    }
}

// MAKR: - UICollectionViewDelegate
extension MyProfileViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if indexPath.row == products.count {
            self.updateStackView.isHidden = false
        }
    }
}


extension MyProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (screenWidth - 2) / 2
        return CGSize(width: cellWidth, height: cellWidth)
    }
}

extension MyProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            selectedImage = image
            Product.updateProduct(image: image) { (product) in
                self.products.append(product)
                self.collectionView.reloadData()
            }
        } else {
            print("JESS: A valid image wasn't selected")
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

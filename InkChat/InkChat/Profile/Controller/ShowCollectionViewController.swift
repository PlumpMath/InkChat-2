//
//  ShowCollectionViewController.swift
//  InkChat
//
//  Created by iOS Dev Log on 2017/5/26.
//  Copyright © 2017年 iOSDevLog. All rights reserved.
//

import UIKit


class ShowCollectionViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var updateStackView: UIStackView!
    
    var screenWidth: CGFloat = 320.0
    var results = [Int]()
    var imagePicker: UIImagePickerController!
    var selectedImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for _ in 0..<5 {
            results.append(Int(arc4random_uniform(4) + 1))
        }
        
        self.imagePicker = UIImagePickerController()
        self.imagePicker.allowsEditing = true
        self.imagePicker.delegate = self
        
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
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pictureSeleccted(_ sender: UIButton) {
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
extension ShowCollectionViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as TattooCollectionViewCell
        
        if indexPath.row == results.count {
            cell.tattooImageView.image = #imageLiteral(resourceName: "add")
        } else if indexPath.row > 4 {
            cell.tattooImageView.image = self.selectedImage
            
        } else {
            let randomIndex = results[indexPath.row]
            cell.tattooImageView.image = UIImage(named: "show_\(randomIndex)")
        }
        
        return cell
    }
}

// MAKR: - UICollectionViewDelegate
extension ShowCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if indexPath.row == results.count {
            self.updateStackView.isHidden = false
        }
    }
}


extension ShowCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (screenWidth - 2) / 2
        return CGSize(width: cellWidth, height: cellWidth)
    }
}

extension ShowCollectionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            selectedImage = image
            self.results.append(1)
        } else {
            print("JESS: A valid image wasn't selected")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
}

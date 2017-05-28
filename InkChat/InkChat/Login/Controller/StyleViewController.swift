//
//  StyleViewController.swift
//  InkChat
//
//  Created by iOS Dev Log on 2017/5/26.
//  Copyright © 2017年 iOSDevLog. All rights reserved.
//

import UIKit

class StyleViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    @IBOutlet weak var rightButtonItem: UIBarButtonItem!
    
     class Style {
        var name: String
        var isSelected: Bool
        
        init(name: String, isSelected: Bool) {
            self.name = name
            self.isSelected = isSelected
        }
    }
    var results = [
       Style(name: "新传统", isSelected: false),
       Style(name: "奇卡诺", isSelected: true),
       Style(name: "old school", isSelected: false),
       Style(name: "new school", isSelected: true),
       Style(name: "老传统", isSelected: false),
       Style(name: "小清新", isSelected: false),
       Style(name: "写实", isSelected: false),
       Style(name: "3D风格", isSelected: false),
       Style(name: "肖像风格", isSelected: false),
       Style(name: "写实风格", isSelected: true),
       Style(name: "几何", isSelected: false),
       ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.flowLayout.estimatedItemSize = CGSize(width: 30, height: 100)
        
        if ad.user?.type == "artist" {
           rightButtonItem.title = "Next"
        } else {
            rightButtonItem.title = "Done"
        }
    }

    @IBAction func rightButtonClicked(_ sender: UIBarButtonItem) {
        if ad.user?.type == "artist" {
            performSegue(withIdentifier: "PriceViewControllerSegue", sender: nil)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func selectAllStyles(_ sender: UIButton) {
        for style in self.results {
            style.isSelected = true
        }
        
        self.collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension StyleViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as StyleCollectionViewCell
        
        let style = results[indexPath.row]
        cell.styleLabel.text = "  \(style.name)  "
        cell.styleLabel.borderWidth = 1
        cell.styleLabel.borderColor = UIColor.white
        cell.styleLabel.clipsToBounds = true
        
        if (style.isSelected) {
            cell.styleLabel.fillColor = UIColor.white
            cell.styleLabel.textColor = UIColor.black
        } else {
            cell.styleLabel.fillColor = UIColor.clear
            cell.styleLabel.textColor = UIColor.white
        }
        
        return cell
    }
}

// MAKR: - UICollectionViewDelegate
extension StyleViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
       
        var style = results[indexPath.row]
        style.isSelected = !style.isSelected
        self.collectionView.reloadData()
    }
}

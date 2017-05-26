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
    
    
    var results = ["新传统", "奇卡诺", "old school", "new school", "老传统", "小清新", "写实", "3D风格", "写实风格", "肖像风格", "几何"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.flowLayout.estimatedItemSize = CGSize(width: 30, height: 100)
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
        
        cell.styleLabel.text = results[indexPath.row]
        if (indexPath.row % 2 == 0) {
            cell.styleLabel.fillColor = UIColor.clear
            cell.styleLabel.layer.borderColor = UIColor.white.cgColor
            cell.styleLabel.textColor = UIColor.white
            cell.styleLabel.clipsToBounds = true
        } else {
            cell.styleLabel.fillColor = UIColor.white
            cell.styleLabel.textColor = UIColor.black
            cell.styleLabel.layer.borderColor = UIColor.white.cgColor
            cell.styleLabel.clipsToBounds = true
        }
        
        return cell
    }
}

// MAKR: - UICollectionViewDelegate
extension StyleViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
       
    }
}

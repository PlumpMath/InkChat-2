//
//  TattooCollectionViewController.swift
//  InkChat
//
//  Created by iOS Dev Log on 2017/5/26.
//  Copyright © 2017年 iOSDevLog. All rights reserved.
//

import UIKit

class TattooCollectionViewController: UICollectionViewController {
    
    var screenWidth: CGFloat = 320.0
    var results = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for _ in 0..<100 {
            results.append(Int(arc4random_uniform(4) + 1))
        }
        
        self.collectionView!.register(TattooCollectionViewCell.self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        screenWidth = (self.collectionView?.bounds.size.width)!
        self.collectionView?.reloadData()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
}

// MARK: UICollectionViewDataSource
extension TattooCollectionViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as TattooCollectionViewCell
        
        let randomIndex = results[indexPath.row]
        
        cell.tattooImageView.image = UIImage(named: "tattoo_\(randomIndex)")
    
        return cell
    }
}

// MAKR: - UICollectionViewDelegate
extension TattooCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        self.performSegue(withIdentifier: "CustomViewControllerSegue", sender: nil)
    }
}


extension TattooCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (screenWidth - 2) / 2
        return CGSize(width: cellWidth, height: cellWidth)
    }
}

//
//  PriceViewController.swift
//  InkChat
//
//  Created by iOS Dev Log on 2017/5/28.
//  Copyright © 2017年 iOSDevLog. All rights reserved.
//

import UIKit

class PriceViewController: UIViewController {

    @IBOutlet weak var priceLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func choosePrice(_ sender: UISlider) {
        let price = Double(sender.value).format(f: ".-2f")
        self.priceLabel.text = "\(price)RMB"
    }

}

//
//  ViewController.swift
//  HelloWorld1
//
//  Created by Owner on 2020/06/02.
//  Copyright © 2020 Owner. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var myLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    @IBAction func changeText(_ sender: Any) {
            myLabel.text = "文字が変更されました。"
    }
    
    @IBAction func ButtonPush(_ sender: Any) {
        if myLabel.isHidden == true {
            myLabel.isHidden = false
        }else{
            myLabel.isHidden = true
        }
    }
    
    
}


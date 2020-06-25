//
//  ViewController.swift
//  Counter
//
//  Created by Owner on 2020/06/03.
//  Copyright © 2020 Owner. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var countLabel: UILabel!
    var count = Int()
    
    var countLabelText = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        count = 0
    }

    @IBAction func minusPushed(_ sender: Any) {
        if count > 0{
            count -= 1
        }
        countLabelText = "\(count)"
        if count >= 0 && count < 10{
            countLabel.textColor = UIColor.black
        }else if count >= 10 && count < 20 {
            countLabel.textColor = UIColor.green
        } else if count >= 20 && count < 30 {
            countLabel.textColor = UIColor.yellow
        } else {
            countLabel.textColor = UIColor.red
        }
        countLabel.text = countLabelText
    }
    @IBAction func plusPushed(_ sender: Any) {
        count += 1
        countLabelText = "\(count)"
        if count >= 0 && count < 10{
            countLabel.textColor = UIColor.black
        }else if count >= 10 && count < 20 {
            countLabel.textColor = UIColor.green
        } else if count >= 20 && count < 30 {
            countLabel.textColor = UIColor.yellow
        } else {
            countLabel.textColor = UIColor.red
        }
        countLabel.text = countLabelText
    }
    
    @IBAction func resetPushed(_ sender: Any) {
        count = 0
        countLabelText = "\(count)"
        countLabel.textColor = UIColor.black
        countLabel.text = countLabelText
    }
}


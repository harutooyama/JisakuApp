//
//  ViewController.swift
//  Coller
//
//  Created by Owner on 2020/06/10.
//  Copyright © 2020 Owner. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var colorLabel: UILabel!
    var label = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toResult" {
            let nextv = segue.destination as! ResultViewController
            nextv.label = self.label
        }
    }
    @IBAction func backView(segue: UIStoryboardSegue) {
        
    }

    @IBAction func pushedRed(_ sender: Any) {
        label = "red"
        colorLabel.textColor = UIColor.red
    }
    @IBAction func pushedYellow(_ sender: Any) {
        label = "yellow"
        colorLabel.textColor = UIColor.yellow
    
    }
    
    @IBAction func pushedBlue(_ sender: Any) {
        label = "blue"
        colorLabel.textColor = UIColor.blue
    }
}


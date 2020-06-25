//
//  ResultViewController.swift
//  Coller
//
//  Created by Owner on 2020/06/10.
//  Copyright © 2020 Owner. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    
    @IBOutlet weak var resultcolorLabel: UILabel!
    var label = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        switch label{
        case "red":
            resultcolorLabel.text = self.label
            resultcolorLabel.textColor = UIColor.red
        case "yellow":
            resultcolorLabel.text = self.label
            resultcolorLabel.textColor = UIColor.yellow
        case "blue":
            resultcolorLabel.text = self.label
            resultcolorLabel.textColor = UIColor.blue
        default:
            break
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

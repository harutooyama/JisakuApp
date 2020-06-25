//
//  ResultViewController.swift
//  Quiz
//
//  Created by Owner on 2020/06/04.
//  Copyright © 2020 Owner. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!

    @IBOutlet weak var LabelImage: UIImageView!
    var correctPercentage = Int()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if correctPercentage < 30{
            levelLabel.text = "猿レベル"
            LabelImage.image = UIImage(named:"bad")
        }else if correctPercentage >= 30 && correctPercentage<90{
            levelLabel.text = "一般人レベル"
            LabelImage.image = UIImage(named:"normal")
        }else if correctPercentage >= 90{
            levelLabel.text = "天才レベル"
            LabelImage.image = UIImage(named:"good")
        }
        percentageLabel.text = String(format:"%d %%",correctPercentage)

        // Do any additional setup after loading the view.
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

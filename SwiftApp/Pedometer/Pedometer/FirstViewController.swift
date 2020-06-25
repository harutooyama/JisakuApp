//
//  FirstViewController.swift
//  Pedometer
//
//  Created by Owner on 2020/06/09.
//  Copyright © 2020 Owner. All rights reserved.
//

import UIKit
import CoreMotion
import MessageUI

class FirstViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var stepCountLabel: UILabel!
    
    var pedometer = CMPedometer()
    var stepCount = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        startStepCounting()
    }
    
    func startStepCounting(){
        if(CMPedometer.isStepCountingAvailable()){
            self.pedometer.startUpdates(from: NSDate() as Date){
                (data: CMPedometerData?,error) -> Void in
                DispatchQueue.main.async(execute:{() -> Void in
                    if(error == nil){
                        self.stepCount = Int(data!.numberOfSteps)
                            self.stepCountLabel.text = "\(self.stepCount)"
                    }
                })
            }
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func reset(){
        self.stepCount = 0
        pedometer = CMPedometer()
        startStepCounting()
        self.stepCountLabel.text = "\(self.stepCount)"
    }

    @IBAction func sendMail(_ sender: Any) {
        let mailViewController = MFMailComposeViewController()
        
        let subject = "歩きました!"
        let message = String(format: "たった今、私は %d 歩きました！",stepCount)
        mailViewController.mailComposeDelegate = self
        mailViewController.setSubject(subject)
        mailViewController.setMessageBody(message,isHTML:false)
        self.present(mailViewController,animated: true, completion: nil)
        
    }
    
    @IBAction func resetButtonAction(_ sender: Any) {
        self.reset()
    }
}


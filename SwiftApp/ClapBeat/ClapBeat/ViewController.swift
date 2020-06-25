//
//  ViewController.swift
//  ClapBeat
//
//  Created by Owner on 2020/06/04.
//  Copyright © 2020 Owner. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource,UIPickerViewDelegate{
    

     let clapInstance = Clap()
     var repeatNumbersForPicker = NSMutableArray()
    
     var repeatNumbersArray:[String] = []
     var repeatCount = Int()
    

    @IBOutlet weak var PickerView: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        repeatCount = 1
        
        for i in 0 ..< 10{
            let numberText = String(format: "%d回",i+1)
            repeatNumbersForPicker[i] = numberText
            repeatNumbersArray.append(numberText)
        }
        PickerView.delegate = self
        PickerView.dataSource = self
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 10
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return repeatNumbersArray[row] as? String
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        repeatCount = row+1
    }
    

    @IBAction func Playsender(_ sender: Any) {
        clapInstance.repeatClap(count: repeatCount)
    }
    
}


//
//  ViewController.swift
//  DollerYen
//
//  Created by Owner on 2020/06/03.
//  Copyright © 2020 Owner. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate{

    
    @IBOutlet weak var inputCurrency: UILabel!
    @IBOutlet weak var inputField: UITextField!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var resultCurrency: UILabel!
    @IBOutlet weak var selector: UISegmentedControl!
    
    var input = Double()
    var result = Double()
    var rate = Double()
    // 「円→ドル」or「ドル→円」の計算方法を記録するためのbool変数
    // 「円→ドル」ならば「true」、「ドル→円」ならば「false」
    var isYenToDollar = Bool()
    // ▲▲ 追加 ▲▲

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        rate = 120.0
        input = 0
        result = 0
        rateLabel.text = String(format: "%.1f", rate)
        isYenToDollar = true
        inputField.delegate = self
    }
    func convert(){
        if isYenToDollar == true{//円→ドル
            result = input/rate;
            resultLabel.text = String(format:"%.2f",result)
            
        }else if isYenToDollar == false{//ドル→円
            result = input*rate
            resultLabel.text = String(format:"%.0f",result)
        }
    }

    
    @IBAction func changeCalcMethod(_ sender: AnyObject) {
        
        if sender.selectedSegmentIndex == 0{
            isYenToDollar = true
            inputCurrency.text = "円"
            resultCurrency.text = "ドル"
        }else if sender.selectedSegmentIndex == 1{
            isYenToDollar = false
            inputCurrency.text = "ドル"
            resultCurrency.text = "円"
        }
        self.convert()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 受け取った入力値（String型の文字列）をDoubleに変換し、inputに代入
        input = atof(textField.text!)
        // キーボードを閉じる
        textField.resignFirstResponder()
        //通貨を変換
        self.convert()
        return true
    }
    
}


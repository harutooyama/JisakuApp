//
//  Problem.swift
//  Quiz
//
//  Created by Owner on 2020/06/04.
//  Copyright © 2020 Owner. All rights reserved.
//

import UIKit

class Problem: NSObject {
    
    var question = String()
    var answer = Int()
    
    func setQ(q:String,a:Int){
        
        question = q
        
        answer = a
    }
    func getQ() -> String{
        print(question)
        return question
    }
    func getA() -> Int{
        return answer
    }
    
}

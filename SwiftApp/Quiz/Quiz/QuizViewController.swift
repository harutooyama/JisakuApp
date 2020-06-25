//
//  QuizViewController.swift
//  Quiz
//
//  Created by Owner on 2020/06/04.
//  Copyright © 2020 Owner. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController {


    @IBOutlet weak var problemText: UITextView!
    @IBOutlet weak var questionText: UITextView!
    var problemSet = NSMutableArray()
    var totalProblems = Int()
    var currentProblem = Int()
    var correctAnswers = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.loadProblemSet()
        self.shuffleProblemSet()
        
        totalProblems = 10
        currentProblem = 0
        correctAnswers = 0
        
        let questions = problemSet.object(at:currentProblem) as! Problem
        
        questionText.text = questions.getQ()
        problemText.text = questions.getQ()
    }
    
    @IBAction func answerIsTrue(_ sender: Any) {
        let questions = problemSet.object(at:currentProblem) as! Problem
        if questions.getA() == 0{
            correctAnswers += 1
        }
        self.nextProblem()
        
    }
    
    @IBAction func answerIsFalse(_ sender: Any) {
        let questions = problemSet.object(at:currentProblem) as! Problem
        if questions.getA() == 1{
            correctAnswers += 1
        }
        self.nextProblem()
    }
    
    func loadProblemSet(){
        let path = Bundle.main.path(forResource: "quiz", ofType:"csv")
        let enc = String.Encoding.utf8
        let data = NSData(contentsOfFile: path!)
        let text = String(NSString(data: data as! Data, encoding: enc.rawValue)!)
        
        let lines = text.components(separatedBy:"\n")

        for i in 0..<lines.count{
            let items = lines[i].components(separatedBy:",")

            let p = Problem()
            let q = items[0]
            let a = Int(items[1])
            p.setQ(q: q, a: a!)
            problemSet.add(p)
           
        }
    }
    
    func shuffleProblemSet() {
        let totalQuestions = problemSet.count
        var i = totalQuestions
        while i > 0{
            let j = arc4random() % UInt32(i)
            problemSet.exchangeObject(at:i-1,withObjectAt:Int(j))
            i -= 1
        }
    }
    
    func nextProblem(){
        currentProblem += 1
        if currentProblem < totalProblems{
            let questions = problemSet.object(at:currentProblem) as! Problem
            problemText.text = questions.getQ()
        }else {
            self.performSegue(withIdentifier: "toResultView",sender:self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let percentage = correctAnswers * 100 / totalProblems
        
        if segue.identifier == "toResultView"{
            let rvc = segue.destination as! ResultViewController
            rvc.correctPercentage = percentage
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

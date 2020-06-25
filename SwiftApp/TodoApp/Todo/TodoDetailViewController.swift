//
//  TodoDetailViewController.swift
//  Todo
//
//  Created by Owner on 2020/06/15.
//  Copyright © 2020 asOne. All rights reserved.
//

import UIKit
import RealmSwift

class TodoDetailViewController: UIViewController {

    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var descTextView: UITextView!
    @IBOutlet weak var commitButton: UIButton!
    @IBOutlet weak var trashButton: UIBarButtonItem!
    
    var actionType = ""
    var selectedTodo:ToDo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initView()
    }
    
    func initView() {
        if actionType == "NEW" {
            self.title = "TODO新規追加"
            self.commitButton.setTitle("新規追加", for: .normal)
            self.commitButton.addTarget(self, action: #selector(dbAdd(_:)), for: .touchUpInside)
            self.titleField.text = ""
            self.descTextView.text = ""
            self.navigationItem.rightBarButtonItem = nil
        } else if actionType == "UPDATE" {
            self.title = "TODO編集"
            self.commitButton.setTitle("更新", for: .normal)
            self.commitButton.addTarget(self, action: #selector(dbUpdate(_:)), for: .touchUpInside)
            self.titleField.text = selectedTodo.name
            self.descTextView.text = selectedTodo.desc
        }
    }
    
    @objc func dbAdd(_ sender: UIButton) {
        if isValidateInputContents() == false {return}
        
        let toDo = ToDo()
        toDo.name = titleField.text!
        toDo.desc = descTextView.text!
        toDo.createDate = NSDate()
        print(toDo.name)

        do {
            let realm = try! Realm()
            print(toDo)
            try! realm.write {realm.add(toDo)}
            print("DB登録成功")
        } catch {
            print("DB登録失敗")
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func dbUpdate(_ sender: UIButton) {
        do {
            let realm = try Realm()
            try realm.write {
                selectedTodo.name = self.titleField.text!
                selectedTodo.desc = self.descTextView.text!
                selectedTodo.updateDate = NSDate()
            }
            print("DB更新成功")
        } catch {
            print("DB更新失敗")
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    private func isValidateInputContents() -> Bool {
        if let title = titleField.text {
            if title.count == 0 {return false}
        } else {
            return false
        }
        
        return true
    }

    @IBAction func dbDelete(_ sender: Any) {
        do {
            let realm = try Realm()
            try realm.write {realm.delete(selectedTodo)}
        } catch {
            print("失敗")
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
}

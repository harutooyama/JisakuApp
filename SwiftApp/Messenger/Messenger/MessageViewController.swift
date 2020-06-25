//
//  MessageViewController.swift
//  Messenger
//
//  Created by Owner on 2020/06/11.
//  Copyright © 2020 Owner. All rights reserved.
//

import UIKit
import NCMB

class MessageViewController: UIViewController ,UITableViewDataSource,UITextFieldDelegate{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath)
        let msg = messages.object(at: indexPath.row) as! NCMBObject
        cell.textLabel!.text = msg.object(forKey: "text") as? String
        return cell
    }
    
    
    
    
    var room = NCMBObject()
    var messages = NSArray()
    @IBOutlet weak var buttonMargin: NSLayoutConstraint!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        messageTextField.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        fetchMessages()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
   
    
    func fetchMessages(){
        let query = NCMBQuery(className: "Message")
        query!.whereKey("room", equalTo: room)
        query!.order(byAscending: "createDate")
        query!.findObjectsInBackground({(objects, error) in
            if (error == nil) {
                if(objects!.count > 0) {
                    self.messages = objects as! NSArray;
                    self.tableView.reloadData()
                } else {
                    print("エラー")
                }
            } else {
                print(error!.localizedDescription)
            }
        })
    }
    @IBAction func sendMessageButtonTapped(_ sender: Any) {
        let msgStr = messageTextField.text

        if (msgStr?.count)! > 0 {

            let msg = NCMBObject(className: "Message")
            msg!.setObject(msgStr, forKey: "text")
            msg!.setObject(room, forKey: "room")

            msg!.saveInBackground({(error) in
                if (error != nil) {
                    print("Message:保存失敗:\(error)")
                }else{
                    print("Message:保存成功:\(msg)")
                    // TableView更新
                    self.fetchMessages()
                    // テキストフィールドの入力内容をリセット
                    self.messageTextField.text = ""
                }
            })
        }
        messageTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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

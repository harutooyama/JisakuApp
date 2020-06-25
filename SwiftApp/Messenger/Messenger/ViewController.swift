//
//  ViewController.swift
//  Messenger
//
//  Created by Owner on 2020/06/11.
//  Copyright © 2020 Owner. All rights reserved.
//

import UIKit

class ViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    var users = NSArray()
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        print("タップされました")
        let selectedUser = users.object(at: indexPath.row) as! NCMBUser
        let myUser = NCMBUser.current()
        self.checkRoomExist(myUser: myUser!, selectedUser: selectedUser)
    }
    
    func createRoom(myUser: NCMBUser,selectedUser: NCMBUser){
        let room = NCMBObject(className: "Room")
        room?.setObject("\(myUser.userName) <--> \(selectedUser.userName)", forKey: "roomName")
        room?.setObject([myUser,selectedUser], forKey: "users")
        room?.saveInBackground({(error) in
            if(error != nil){
                print("Room保存失敗:\(error)")
            }else{
                print("Room保存成功:\(room)")
                self.performSegue(withIdentifier: "toMessage", sender: room)
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath)
        let user = users.object(at: indexPath.row) as! NCMBUser
        cell.textLabel!.text = user.userName
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        
        self.loginCheck()
    }
    func loginCheck(){
        if(NCMBUser.current() != nil){
            print("ログイン済み")
            fetchUserList()
        }else{
            print("未ログイン")
            self.performSegue(withIdentifier: "toLogin", sender: nil)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return 1
    }
    func fetchUserList(){
        let query = NCMBQuery(className: "user")
        query?.whereKey("objectId", notEqualTo: NCMBUser.current().objectId)
        query!.findObjectsInBackground({(objects, error) in
            if(error != nil){
                print("ユーザ取得失敗:\(error)")
            }else{
                print("ユーザ取得成功:\(objects)")
                self.users = objects as! NSArray
                self.tableView.reloadData()
            }
        })
    }
    
    func checkRoomExist(myUser:NCMBUser,selectedUser:NCMBUser){
        let query = NCMBQuery(className: "Room")
        query?.whereKey("users",containsAllObjectsInArrayTo : [myUser,selectedUser])
        query?.findObjectsInBackground({(objects,error) in
            if(error != nil){
                print("RoomUser取得失敗:\(error)")
            }else{
                print("RoomUser取得成功:\(objects)")
                if(objects?.count)! > 0{
                    print("Room作成済")
                    let room = objects![0] as! NCMBObject
                    self.performSegue(withIdentifier: "toMessage", sender: room)
                }else{
                    print("Room未作成")
                    self.createRoom(myUser: myUser, selectedUser: selectedUser)
                }
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMessage"{
            let vc = segue.destination as! MessageViewController
            vc.room = sender as! NCMBObject
        }
    }
    @IBAction func logoutButtonTapped(_ sender: Any) {
        NCMBUser.logOut()
        self.loginCheck()
    }

}


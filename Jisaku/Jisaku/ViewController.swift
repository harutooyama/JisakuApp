//
//  ViewController.swift
//  Jisaku
//
//  Created by Owner on 2020/06/22.
//  Copyright © 2020 Owner. All rights reserved.
//

import UIKit
import NCMB
import Foundation

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

   
    var threads = NSArray()
    var cellObjectId:String = ""
    let uuid = UIDevice.current.identifierForVendor?.uuidString
    var userId:String = ""
    var re2:Bool! = nil
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        userCheck()
        DispatchQueue.global().async{
            self.deleteThreadAndResponse()
            
        }
        wait({return self.re2 == nil}){
            self.fetchThread()
        }
    }

    func fetchThread(){
        
        let query = NCMBQuery(className: "thread")

        query!.order(byAscending: "createDate")
        
        query!.findObjectsInBackground({(objects, error) in
            if (error == nil) {
                if(objects!.count > 0) {
                    print(objects!)
                    self.threads = objects! as NSArray;
                    self.tableView.reloadData()
                } else {
                    print("エラー")
                }
            } else {
                print(error!.localizedDescription)
            }
        })
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let thr = threads.object(at: indexPath.row) as! NCMBObject
        cell.textLabel!.text = thr.object(forKey: "threadName") as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let thr = threads.object(at: indexPath.row) as! NCMBObject
        cellObjectId = (thr.objectId)!
        print(cellObjectId)
        self.performSegue(withIdentifier: "toResult", sender: self)
    }
    


    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return threads.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("segue")
        if segue.identifier == "toResult" {
            print("asadff")
            let rvc = segue.destination as! ResponseViewController
            rvc.objectId = cellObjectId
            rvc.userId = userId
            print(rvc.objectId)
        }else if segue.identifier == "toCreate"{
            let prvc = segue.destination as! PostResultViewController
            prvc.userId = userId
        }
    }
    
    @IBAction func TappedReflesh(_ sender: Any) {
        fetchThread()
    }
    
    
    func userCheck(){
        
        let query = NCMBQuery(className: "users")
        query!.whereKey("ipAddress",equalTo: self.uuid)
        let now = NSDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let nowDate = formatter.string(from: now as Date)
        var ret:Bool! = nil
        var createDate:String = ""
        var objectId = ""
        
        DispatchQueue.global().async {
            query!.findObjectsInBackground({(objects, error) in
                if (error == nil) {
                    if(objects!.count > 0) {
                        self.userId = (objects![0] as AnyObject).object(forKey:"userId") as! String
                        objectId = (objects![0] as AnyObject).objectId
                        createDate = (objects![0] as AnyObject).object(forKey:"createDate") as! String
                        createDate = createDate.prefix(10).replacingOccurrences(of: "-", with: "/")
                        ret = false
                    }else{
                        ret = true
                    }
                } else {
                    print(error!.localizedDescription)
                }
            })
        }
        // dataを取得するまで待ちます
        wait( { return ret == nil } ) {
            if(createDate != nowDate && ret == false){
                self.deleteUser(objectId: objectId)
                self.createUser()
            }else if(ret == true){
                
                self.createUser()
                query!.findObjectsInBackground({(objects, error) in
                if (error == nil) {
                    if(objects!.count > 0) {
                        self.userId = (objects![0] as AnyObject).object(forKey:"userId") as! String
                        
                    }else{
                        print("エラー")
                    }
                }})
            }
        }
        
    }
    func createUser(){
        let userId:String = randomString(length: 8)
        
        let user = NCMBObject(className: "users")
        user!.setObject(uuid,forKey:"ipAddress")
        user!.setObject(userId, forKey:"userId")
        
        user?.saveInBackground({(error) in
            if (error != nil) {
                print("Message:保存失敗:\(error)")
            }else{
                print("Message:保存成功:\(user)")
            }
        })
        
    }
    
    func randomString(length: Int) -> String {

        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)

        var randomString = ""

        for _ in 0 ..< length {
            let Rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(Rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }

        return randomString
    }
    func deleteUser(objectId:String?){
        let object : NCMBObject = NCMBObject(className: "users")

        // objectIdプロパティを設定
        object.objectId = objectId
        
        // データストアから削除
        object.deleteInBackground({(result) in
            if( result == nil){
                print(objectId)
                print("削除に成功しました")
            }else{
                print("削除に失敗しました: \(result)")
            }
        })

    }
    func wait(_ waitContinuation: @escaping (()->Bool), compleation: @escaping (()->Void)) {
        var wait = waitContinuation()
        
        let semaphore = DispatchSemaphore(value: 0)
        DispatchQueue.global().async {
            while wait {
                DispatchQueue.main.async {
                    wait = waitContinuation()
                    semaphore.signal()
                }
                semaphore.wait()
                Thread.sleep(forTimeInterval: 0.01)
            }
            // 待機条件をクリアしたので通過後の処理を行います。
            DispatchQueue.main.async {
                compleation()
            }
        }
    }
    
    func deleteThreadAndResponse(){
        print("デリート")
        let query = NCMBQuery(className: "thread")
        let query1 = NCMBQuery(className: "response")
        let now = NSDate()
        let formatter = DateFormatter()
        var deleteThreads = NSArray()
        var deleteResponse = NSArray()
        var createDate:String = ""
        var deleteListPointer:[Int] = []
        var deleteThreadsObjectIdList:[String] = []
        var deleteResponseObjectIdList:[String] = []
        var re:Bool! = nil
        var re1:Bool! = nil
        formatter.dateFormat = "yyyy/MM/dd"
        let nowDate = formatter.string(from: now as Date)
        
        DispatchQueue.global().async {
            
            query!.findObjectsInBackground({(objects, error) in
                if (error == nil) {
                   
                    if(objects!.count > 0) {
                        deleteThreads = objects! as NSArray
                        
                        for i in 0..<deleteThreads.count{
                            let thr = deleteThreads.object(at: i) as! NCMBObject
                            createDate = (thr.object(forKey: "createDate") as? String)!
                            createDate = createDate.prefix(10).replacingOccurrences(of: "-", with: "/")
                                
                            if(createDate != nowDate){
                                deleteListPointer.append(i)
                                deleteThreadsObjectIdList.append(thr.objectId)
                                
                            }
                        }
                    }
                } else {
                    print(error!.localizedDescription)
                }
            })
            query1!.findObjectsInBackground({(objects, error) in
                print("asdfafa")
                if (error == nil) {
                    if(deleteThreads.count > 0) {
                        print("レス削除始まり")
                        deleteResponse = objects! as NSArray
                        if(deleteResponseObjectIdList.count > 0){
                            for p in deleteListPointer {
                                let res = deleteResponse.object(at: p) as! NCMBObject
                                deleteResponseObjectIdList.append(res.objectId)
                            }
                        }else{
                            self.re2 = true
                        }
                        re = true
                    }else{
                        re = false
                        self.re2 = true
                    }
                } else {
                    print(error!.localizedDescription)
                }
            })
        }
        wait( { return re == nil } ) {
            if(re == true){
                DispatchQueue.global().async{
                    let thrObject : NCMBObject = NCMBObject(className: "thread")
                    for thrid in deleteThreadsObjectIdList{
                        thrObject.objectId = thrid
                        print(thrObject.objectId)
                        thrObject.deleteInBackground({(result) in
                            if( result == nil){
                                print("Thread削除に成功しました")
                                
                            }else{
                                print(thrObject.objectId)
                                print("削除に失敗しました: \(result)")
                               
                            }
                            if(thrid == deleteThreadsObjectIdList[deleteThreadsObjectIdList.count - 1]){
                                re1 = true
                            }
                        })
                    }
                }
                self.wait({return re1 == nil}){
                    DispatchQueue.global().async{
                        let resObject : NCMBObject = NCMBObject(className: "response")
                        for resid in deleteResponseObjectIdList{
                            resObject.objectId = resid
                            print(resObject.objectId)
                            resObject.deleteInBackground({(result) in
                                if( result == nil){
                                    print("Response削除に成功しました")
                                    
                                }else{
                                    print("削除に失敗しました: \(result)")
                                    
                                }
                                if(deleteResponseObjectIdList.count == 0 || resid == deleteResponseObjectIdList[deleteResponseObjectIdList.count-1]){
                                    self.re2 = true
                                }
                            })
                            
                        }
                    }
                }
            }
        }
    }
}
    




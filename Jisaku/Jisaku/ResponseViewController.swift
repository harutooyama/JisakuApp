//
//  ResponseViewController.swift
//  Jisaku
//
//  Created by Owner on 2020/06/23.
//  Copyright © 2020 Owner. All rights reserved.
//

import UIKit
import NCMB

class ResponseViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var response = NSArray()
    var threads = NSArray()
    
    var userId:String = ""
    var objectId:String = ""
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 5
        tableView.rowHeight = UITableView.automaticDimension
        fetchResponse()
        // Do any additional setup after loading the view.
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return response.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.numberOfLines=0
        let res = response.object(at: indexPath.row) as! NCMBObject
        let resLabel = cell.viewWithTag(1) as! UILabel
        var createDate:String = res.object(forKey:"createDate") as! String
        let idLabel = cell.viewWithTag(2) as! UILabel
        resLabel.numberOfLines=0
        resLabel.sizeToFit()
        resLabel.text = res.object(forKey: "res") as? String
        idLabel.text = "ID:" + ((res.object(forKey: "userId") as? String)!) + "             "  + createDate
        
        return cell
    }
    
    
    func fetchResponse(){

        let query = NCMBQuery(className: "response")
        let query1 = NCMBQuery(className: "thread")
        query1!.whereKey("objectId",equalTo: objectId)
        query!.whereKey("threadId",equalTo: objectId)
        
        
        query!.findObjectsInBackground({(objects, error) in
            if (error == nil) {
                if(objects!.count > 0) {
                    print(objects!)
                    self.response = objects! as NSArray;
                    self.tableView.reloadData()
                } else {
                    print("エラー")
                }
            } else {
                print(error!.localizedDescription)
            }
        })
        query1!.findObjectsInBackground({(objects, error) in
            if (error == nil) {
                if(objects!.count > 0) {
                    print(objects!)
                    self.navigationItem.title = (objects![0] as AnyObject).object(forKey:"threadName") as! String
                    self.tableView.reloadData()
                } else {
                    print("エラー")
                }
            } else {
                print(error!.localizedDescription)
            }
        })
        

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("segue")
        if segue.identifier == "toPost" {
            print("asadff")
            let prvc = segue.destination as! PostResponseViewController
            prvc.objectId = objectId
            prvc.userId = userId
            print(prvc.objectId)

            
        }
    }
    @IBAction func RefleshButtonTapped(_ sender: Any) {
        fetchResponse()
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

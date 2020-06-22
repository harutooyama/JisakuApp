//
//  ViewController.swift
//  Jisaku
//
//  Created by Owner on 2020/06/22.
//  Copyright © 2020 Owner. All rights reserved.
//

import UIKit
import NCMB


class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    var thread = NCMBObject()
    var threads = NSArray()
    
    @IBOutlet weak var tableView: UITableView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMessages()
    }

    func fetchMessages(){
        let query = NCMBQuery(className: "thread")
        query!.whereKey("thread", equalTo: thread)
        query!.order(byAscending: "createDate")
        query!.findObjectsInBackground({(objects, error) in
            if (error == nil) {
                if(objects!.count > 0) {
                    self.threads = objects as! NSArray;
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

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return threads.count
    }
    
}



//
//  ViewController.swift
//  RSSReader
//
//  Created by Owner on 2020/06/09.
//  Copyright © 2020 asOne. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var table: UITableView!
    
    var elementList = NSMutableArray()
    var urlForDetailView = NSURL()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.dataSource = self
        table.delegate = self
        getJSON()
    }
    
    func getJSON() {
        let urlString = "http://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=8c4cf9ab8a14487eacb7272707ad0f55"
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        Alamofire.request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON {
            (response:DataResponse<Any>) in
            switch(response.result) {
            case .success( _):
                print("\(urlString)の取得に成功しました")
                
                if let jsonDic = response.result.value as? NSDictionary {
                    print(jsonDic)
                    let articlesData = jsonDic["articles"] as! NSArray

                    for i in 0 ..< articlesData.count {
                        let n = News()
                        n.title = ((articlesData[i] as Any) as AnyObject).object(forKey: "title") as! String
                        n.url = ((articlesData[i] as Any) as AnyObject).object(forKey: "url") as! String
                        n.date = ((articlesData[i] as Any) as AnyObject).object(forKey: "publishedAt") as! String
                        self.elementList.add(n)
                    }
                }
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.table.reloadData()
            case .failure( _):
                print("\(urlString)の取得に失敗しました")
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elementList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath as IndexPath)
        
        let titleLabel = cell.viewWithTag(1) as! UILabel
        let dateLabel = cell.viewWithTag(2) as! UILabel
        
        let f = elementList.object(at: indexPath.row) as! News
        titleLabel.text = f.title
        dateLabel.text = f.date
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let n = elementList.object(at: indexPath.row) as! News
        let selectedURL = n.url
        urlForDetailView = NSURL(string: selectedURL)!
        
        self.performSegue(withIdentifier: "toDetailView", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailView" {
            let nvc = segue.destination as! NewsDetailViewController
            nvc.urlToRSSReaderView = urlForDetailView
        }
    }
    
    @IBAction func refreshList(_ sender: Any) {
        getJSON()
    }
    
    @IBAction func backView(segue: UIStoryboardSegue) {
        
    }

}


//
//  ViewController.swift
//  Deai
//
//  Created by Owner on 2020/06/17.
//  Copyright © 2020 Owner. All rights reserved.
//

import UIKit
import NCMB


class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var interestedInwomen: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ncmbLoginCheck()
    }

    func ncmbLoginCheck(){
        if (NCMBUser.current() != nil) {
            print("ログイン済み")
            self.setMyPicture()
        }else {
            print("未ログイン")
            self.performSegue(withIdentifier: "toLogin", sender: nil)
        }
    }
    func setMyPicture(){
        let user = NCMBUser.current()
        print("user:\(user)")
        let fbPictureUrl = "https://graph.facebook.com/" + user!.userName + "/picture?type=large"
        if let fbpicUrl = NSURL(string: fbPictureUrl){
            if let data = NSData(contentsOf: fbpicUrl as URL){
                self.imageView.image = UIImage(data:data as Data)
            }
        }
    }
    
    @IBAction func logoutButtonTapped(sender: AnyObject){
        NCMBUser.logOut()
        ncmbLoginCheck()
    }
    
    @IBAction func startButtonTapped(sender: AnyObject) {
   
        let user = NCMBUser.current()
        user!.setObject(interestedInwomen.isOn, forKey: "interestedInWomen")
        user!.saveEventually({(error) in
            if (error != nil) {
                print("保存失敗:\(error)")
            }else{
                print("保存成功:\(user)")
        
                self.performSegue(withIdentifier: "toTinder", sender: nil)
            }
        })
    }


}


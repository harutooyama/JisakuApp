//
//  FBLoginViewController.swift
//  Deai
//
//  Created by Owner on 2020/06/17.
//  Copyright © 2020 Owner. All rights reserved.
//

import UIKit
import NCMB
import FBSDKCoreKit
import FBSDKLoginKit


class FBLoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginFacebookAction(sender: AnyObject) {
        let fbLoginManager : LoginManager = LoginManager()
        fbLoginManager.logIn(permissions: ["email"], from: self) { (result, error) -> Void in
            if (error == nil){
                print("FBログイン成功")
                
                let fbloginresult : LoginManagerLoginResult = result!
                if(fbloginresult.grantedPermissions.contains("email")){
                    self.returnUserData()
                }
            } else {
                print("FBログイン失敗:\(error)")
            }
        }
    }
    @IBAction func loginAction(sender: AnyObject){
        
        
        let userId = "root"
        let password = "root"
        NCMBUser.logInWithUsername(inBackground: userId, password: password, block:({(user, error) in
            if (error != nil){
                print("ログイン失敗:\(error)")
               
                user?.userName = "root"
                user?.password = password
                user?.mailAddress = "root@example.com"
                //user.setObject(result.value(forKey: "gender") as! String, forKey: "gender")
                user?.setObject("root", forKey: "fullname")
                      
                let acl = NCMBACL()
                acl.setPublicReadAccess(true)
                acl.setPublicWriteAccess(true)
                user?.acl = acl
                print("in")
                user?.signUpInBackground({(error) in
                    if (error != nil){
                        print("ユーザ登録失敗:\(error)")
                    }else{
                        print("ユーザ登録完了:\(user)")
                           
                        self.navigationController?.popToRootViewController(animated: true)
                        }
                    print(error)
                })
                print("out")
            }else{
                print("ログイン成功:\(user)")
         
                self.navigationController?.popToRootViewController(animated: true)
            }
        }))
        
    }
    // ユーザ情報取得
    func returnUserData() {
        let graphRequest:GraphRequest = GraphRequest(graphPath: "me",
                                                               parameters: ["fields": "id,email,gender,link,locale,name,timezone,updated_time,verified,last_name,first_name,middle_name"])
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            if ((error) != nil) {
                print("FBユーザ情報取得失敗: \(error)")
            }else{
                print("FBユーザ情報取得成功: \(result)")
                
                self.ncmbLogin(result: result as AnyObject)
            }
        })
    }
    
    func ncmbLogin(result:AnyObject){
       
        let userId = result.value(forKey: "id") as! String
      
        let ud = UserDefaults.standard
        var password = ""
        if let passwd = ud.object(forKey: "password") {
            password = passwd as! String
        } else {
            password = NSUUID().uuidString
            ud.set(password, forKey: "password")
        }
        NCMBUser.logInWithUsername(inBackground: userId, password: password, block:({(user, error) in
            if (error != nil){
                print("ログイン失敗:\(error)")
               
                self.ncmbUserRegister(result: result,password: password)
            }else{
                print("ログイン成功:\(user)")
         
                self.navigationController?.popToRootViewController(animated: true)
            }
        }))
    }
    
    func ncmbUserRegister(result:AnyObject,password:String) {
        let user = NCMBUser()
        user.userName = result.value(forKey: "id") as! String
        user.password = password
        user.mailAddress = result.value(forKey: "email") as! String
        //user.setObject(result.value(forKey: "gender") as! String, forKey: "gender")
        user.setObject(result.value(forKey: "name") as! String, forKey: "fullname")
        
        let acl = NCMBACL()
        acl.setPublicReadAccess(true)
        acl.setPublicWriteAccess(true)
        user.acl = acl
  
        user.signUpInBackground({(error) in
            if (error != nil){
                print("ユーザ登録失敗:\(error)")
            }else{
                print("ユーザ登録完了:\(user)")
             
                self.navigationController?.popToRootViewController(animated: true)
            }
        })
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

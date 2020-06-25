//
//  UserRegisterViewController.swift
//  PhotoShare
//
//  Created by Owner on 2020/06/12.
//  Copyright © 2020 asOne. All rights reserved.
//

import UIKit

class UserRegisterViewController: UIViewController {

    @IBOutlet weak var userIdTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordTextField.isSecureTextEntry = true
    }
    
    @IBAction func userRegisterButtonTapped(_ sender: Any) {
        let user = NCMBUser()
        user.userName = self.userIdTextField.text
        user.password = self.passwordTextField.text
        
        let acl = NCMBACL()
        acl.setPublicReadAccess(true)
        user.acl = acl
        
        user.signUpInBackground({(error) in
            if error != nil {
                print("ユーザ登録失敗\(error)")
            } else {
                print("ユーザ登録完了")
                let alert = UIAlertController(title: "登録完了", message: "ユーザ登録完了しました。", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action:UIAlertAction) -> Void in
                    self.navigationController?.popToRootViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
}

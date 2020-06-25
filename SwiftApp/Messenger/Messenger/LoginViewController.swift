//
//  LoginViewController.swift
//  Messenger
//
//  Created by Owner on 2020/06/11.
//  Copyright © 2020 Owner. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var userIdTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        passwordTextField.isSecureTextEntry = true
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        let userId = userIdTextField.text!
        let password = passwordTextField.text!
        NCMBUser.logInWithUsername(inBackground: userId, password: password, block: ({(user,error) in
            if (error != nil){
                print("ログイン失敗：\(error)")
            }else{
                print("ログイン成功：\(user)")
                _ = self.navigationController?.popToRootViewController(animated: true)
            }
        }))
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

//
//  PostResponseViewController.swift
//  Jisaku
//
//  Created by Owner on 2020/06/23.
//  Copyright © 2020 Owner. All rights reserved.
//

import UIKit
import NCMB


class PostResponseViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    var objectId:String = ""
    var userId:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func saveMessage(){
        let msg = NCMBObject(className:"response")
        
        msg!.setObject(textView.text!,forKey:"res")
        msg!.setObject(self.objectId,forKey:"threadId")
        msg!.setObject(self.userId,forKey:"userId")
        
        msg?.saveInBackground({(error) in
            if (error != nil) {
                print("Message:保存失敗:\(error)")

            }else{
                print("Message:保存成功:\(msg)")
            
            }
        })
        
    }
    @IBAction func TouchedPost(_ sender: Any) {
        print(self.objectId)
        saveMessage()
        self.navigationController?.popViewController(animated: true)
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

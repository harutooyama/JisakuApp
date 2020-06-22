//
//  PostResultViewController.swift
//  Jisaku
//
//  Created by Owner on 2020/06/22.
//  Copyright © 2020 Owner. All rights reserved.
//

import UIKit
import NCMB

class PostResultViewController: UIViewController {


    @IBOutlet weak var themebox: UITextField!
    @IBOutlet weak var resLabel: UITextView!
    
    var pickedImage:UIImage!
    var imageFile:NCMBFile!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func sendMessageButtonTapped(sender: AnyObject) {
        
        let themeStr = themebox.text
        let resStr = resLabel.text
        
        if themeStr!.count > 0 && resStr!.count > 0{
            let query = NCMBObject(className: "thread")
            let msg1 = NCMBObject(className: "thread")
            let msg2 = NCMBObject(className: "response")
            let query = NCMBQuery(className: "thread")
            query!.orde
            query!.findObjectsInBackground({(objects, error) in
                if (error == nil) {
                    if(objects!.count > 0) {
                        self.threads = objects as! NSArray;
                       
                    } else {
                        print("エラー")
                    }
                } else {
                    print(error!.localizedDescription)
                }
            })
        
            msg1!.setObject(themeStr, forKey: "threadName")
            msg1!.setObject(threadId, forKey: "threadId")
            msg2!.setObject(resStr, forKey: "res")
            
            msg1?.saveInBackground({(error) in
                if (error != nil) {
                    print("Message:保存失敗:\(error)")
                }else{
                    print("Message:保存成功:\(msg1)")
               
                
                }
            })
            msg2?.saveInBackground({(error) in
            if (error != nil) {
                print("Message:保存失敗:\(error)")
            }else{
                print("Message:保存成功:\(msg2)")
                }
            })
        threadId += 1

    
    
    
    
   
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

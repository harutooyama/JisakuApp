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
    var userId:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    @IBAction func sendMessageButtonTapped(sender: AnyObject) {
        
        let themeStr = themebox.text
        let resStr = resLabel.text
        
        
        if themeStr!.count > 0 && resStr!.count > 0{
            let msg1 = NCMBObject(className: "thread")
            let msg2 = NCMBObject(className: "response")
            
            msg1!.setObject(themeStr, forKey: "threadName")
            msg2!.setObject(resStr, forKey: "res")
            msg2!.setObject(userId, forKey: "userId")
            
            
            var ret:Bool! = nil
            
            DispatchQueue.global().async {
                msg1?.saveInBackground({(error) in
                    if (error != nil) {
                        print("Message:保存失敗:\(error)")
                        ret = false
                    }else{
                        print("Message:保存成功:\(msg1)")
                        ret = true
                        
                    }
                })
            }
            // dataを取得するまで待ちます
            wait( { return ret == nil } ) {
                msg2!.setObject(msg1!.objectId, forKey: "threadId")
                msg2?.saveInBackground({(error) in
                    if (error != nil) {
                        print("Message:保存失敗:\(error)")
                    }else{
                        print("Message:保存成功:\(msg2)")
                    }
                })
            }
        }
        self.navigationController?.popViewController(animated: true)
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
    
}
    
   
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */



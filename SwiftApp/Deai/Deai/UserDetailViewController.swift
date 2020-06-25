//
//  UserDetailViewController.swift
//  Deai
//
//  Created by Owner on 2020/06/17.
//  Copyright © 2020 Owner. All rights reserved.
//

import UIKit
import NCMB
import MessageUI


class UserDetailViewController: UIViewController,MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var mailLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var user = NCMBUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(user.object(forKey: "mailAddress") as? String)
        mailLabel.text = user.object(forKey: "mailAddress") as! String?
        print(mailLabel.text)
        
        let fbPictureUrl = "https://3.bp.blogspot.com/-esJ3eqpx3Vc/XMZ94CFpjHI/AAAAAAABSmE/eJFVEHwpty0fxzrsX_Pmtw89nvUDxQt_QCLcBGAs/s800/ishiki_hikui_man.png"
        
        // Do any additional setup after loading the view.
        if let fbpicUrl = NSURL(string: fbPictureUrl) {
            if let data = NSData(contentsOf: fbpicUrl as URL) {
                self.imageView.image = UIImage(data: data as Data)
            }
        }
    }
    
    @IBAction func contact(sender: AnyObject){
        if MFMailComposeViewController.canSendMail()==false {
            print("Email Send Failed")
            return
        }
        let mailViewController = MFMailComposeViewController()
        let toRecipients = [user.object(forKey: "mailAddress") as! String] //Toのアドレス指定
        mailViewController.mailComposeDelegate = self
        mailViewController.setSubject("「出会いアプリ」メール通知")
        mailViewController.setToRecipients(toRecipients) //Toアドレスの表示
        mailViewController.setMessageBody("", isHTML: false)
        // 画像追加
        let fbPictureUrl = "https://graph.facebook.com/" + NCMBUser.current().userName + "/picture?type=large"
        if let fbpicUrl = NSURL(string: fbPictureUrl) {
            if let data = NSData(contentsOf: fbpicUrl as URL) {
                mailViewController.addAttachmentData(data as Data, mimeType: "image/png", fileName: "image")
            }
        }
        self.present(mailViewController, animated: true, completion: nil)
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        switch result {
        case .cancelled:
            print("メール送信キャンセル")
            break
        case .saved:
            print("メールドラフト保存")
            break
        case .sent:
            print("メール送信完了")
            break
        case .failed:
            print("メール送信失敗")
            break
        default:
            break
        }
        // 画面を閉じる
        self.dismiss(animated: true, completion: nil)
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

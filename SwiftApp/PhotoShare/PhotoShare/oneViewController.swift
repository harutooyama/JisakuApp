//
//  UserDetailViewController.swift
//  PhotoShare
//
//  Created by Owner on 2020/06/12.
//  Copyright © 2020 asOne. All rights reserved.
//

import UIKit
import NCMB

class oneViewController: UIViewController {
    
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var friendRequestedLabel: UILabel!
    @IBOutlet weak var friendRequestButton: UIButton!
    
    var user = NCMBUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userIdLabel.text = user.userName
        self.friendRequestedLabel.isHidden = true
        self.friendRequestButton.setTitle("友達申請", for: .normal)
        self.friendRequestButton.isEnabled = true
        self.friendRequestButton.addTarget(self, action: #selector(UserDetailViewController.sendFriendRequest(_:)), for: .touchUpInside)
        
        self.checkFriendRequestStatus()
        self.checkFriendRequestedBySelectedUser()
    }
    
    func checkFriendRequestStatus() {
        let query = NCMBQuery(className: "FriendRequest")
        query?.whereKey("from", equalTo: NCMBUser.current())
        query?.whereKey("to", equalTo: self.user)
        query?.findObjectsInBackground({(objects, error) in
            if error != nil {
                print("友達申請状況取得失敗\(error)")
            } else {
                print("登録件数:\(objects?.count)")
                let fr = objects?[0] as! NCMBObject
                self.changeDisplayByStatus(friendRequest: fr)
            }
        })
    }

    func changeDisplayByStatus(friendRequest: NCMBObject) {
        let status = friendRequest.object(forKey: "status") as! String
        
        switch status {
        case "pending":
            self.friendRequestButton.setTitle("友達申請中", for: .normal)
            self.friendRequestButton.isEnabled = false
        case "accepted":
            self.friendRequestButton.setTitle("友達承認済み", for: .normal)
            self.friendRequestButton.isEnabled = false
            self.friendRequestButton.isHidden = true
        case "requested":
            self.friendRequestButton.setTitle("承認", for: .normal)
            self.friendRequestButton.isEnabled = true
            self.friendRequestButton.isHidden = false
            self.friendRequestButton.removeTarget(self, action: #selector(UserDetailViewController.sendFriendRequest(_:)), for: .touchUpInside)
            self.friendRequestButton.addTarget(self, action: #selector(UserDetailViewController.acceptFriendRequest(_:)), for: .touchUpInside)
        default:
            self.friendRequestButton.setTitle("友達申請", for: .normal)
            self.friendRequestButton.isEnabled = true
            self.friendRequestButton.addTarget(self, action: #selector(UserDetailViewController.sendFriendRequest(_:)), for: .touchUpInside)
        }
    }

    func checkFriendRequestedBySelectedUser() {
        let query = NCMBQuery(className: "FriendRequest")
        query?.whereKey("from", equalTo: self.user)
        query?.whereKey("to", equalTo: NCMBUser.current())
        query?.findObjectsInBackground({(objects, error) in
            if error != nil {
                print("友達申請状況取得失敗:\(error)")
            } else {
                if objects!.count > 0 {
                    print("objects:\(objects)")
                    let fr = objects?[0] as! NCMBObject
                    if fr.object(forKey: "status") as! String == "pending" {fr.setObject("requested", forKey: "status")}
                    self.changeDisplayByStatus(friendRequest: fr)
                }
            }
        })
    }

    
    
    @IBAction func sendFriendRequest(_ sender: Any) {
        let fr = NCMBObject(className: "FriendRequest")
        fr?.setObject(NCMBUser.current(), forKey: "from")
        fr?.setObject(self.user, forKey: "to")
        fr?.setObject("pending", forKey: "status")
        fr?.saveInBackground({(error) in
            if error != nil {
                print("友達申請保存失敗:\(error)")
            } else {
                print("友達申請保存成功:\(fr)")
                self.changeDisplayByStatus(friendRequest: fr!)
            }
        })
    }
    
    @IBAction func acceptFriendRequest(_ sender: Any) {
        let query = NCMBQuery(className: "FriendRequest")
        query?.whereKey("from", equalTo: self.user)
        query?.whereKey("to", equalTo: NCMBUser.current())
        query?.findObjectsInBackground({(objects, error) in
            if error != nil {
                print("友達申請状況取得失敗:\(error)")
            } else {
                print("登録件数:\(objects?.count)")
                if objects!.count > 0 {
                    let fr = objects?[0] as! NCMBObject
                    fr.setObject("accepted", forKey: "status")
                    fr.saveInBackground({(error) in
                        if error != nil {
                            print("友達申請承認失敗:\(error)")
                        } else {
                            print("友達申請承認成功")
                            let fr = NCMBObject(className: "FriendRequest")
                            fr?.setObject(NCMBUser.current(), forKey: "from")
                            fr?.setObject(self.user, forKey: "to")
                            fr?.setObject("accepted", forKey: "status")
                            fr?.saveInBackground({(error) in
                                if error != nil {
                                    print("友達申請保存失敗:\(error)")
                                } else {
                                    print("友達申請保存成功:\(fr)")
                                    self.changeDisplayByStatus(friendRequest: fr!)
                                }
                            })
                            self.changeDisplayByStatus(friendRequest: fr!)
                        }
                    })
                }
            }
        })
    }

    
}

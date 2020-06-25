//
//  TinderViewController.swift
//  Deai
//
//  Created by Owner on 2020/06/17.
//  Copyright © 2020 Owner. All rights reserved.
//

import UIKit
import CoreLocation
import NCMB

class TinderViewController: UIViewController {

    @IBOutlet weak var userImageView: UIImageView!
    
    let locationManager = CLLocationManager()
    var displayedUser = NCMBUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let gesture = UIPanGestureRecognizer(target: self, action:#selector(self.wasDragged(gesture:)))
        userImageView.addGestureRecognizer(gesture)
        userImageView.isUserInteractionEnabled = true
        self.getCurrentLocationAndDbSave()

    }
    
    func getCurrentLocationAndDbSave(){
        print("geo")
        let status = CLLocationManager.authorizationStatus()
        if(status == CLAuthorizationStatus.notDetermined){
            print("didChangeAuthorizationStatus: \(status)")
            self.locationManager.requestAlwaysAuthorization()
        }
        NCMBGeoPoint.geoPointForCurrentLocation(inBackground: {(geopoint, error) in
            if error != nil{
               print("geo point error:\(error)")
            }else{
                print("geo point error:\(geopoint!.latitude), lon:\(geopoint!.longitude)")
                let user = NCMBUser.current()
                user!.setObject(geopoint, forKey: "geopoint")
                user!.saveEventually({(error) in
                    if error != nil{
                        print("現在地保存失敗:\(error)")
                    }else{
                        print("現在地保存成功:\(user)")
                        self.fetchUser()
                    }
                })
            }
        })
    }
    func fetchUser(){
        //--------------------------------------
        // クエリ1.既にアクションしているリストを取得
        //--------------------------------------
        let query1 = NCMBQuery(className: "Action")
        query1!.whereKey("from", equalTo: NCMBUser.current())
        query1!.findObjectsInBackground({(objects, error) in
            if (error != nil){
                print("アクション取得失敗:\(error)")
            } else {
                print("アクション取得成功:\(objects!)")
                
                let currentGeoPoint = NCMBUser.current().object(forKey: "geopoint") as! NCMBGeoPoint
                print("currentGeoPoint lat:\(currentGeoPoint.latitude), lon:\(currentGeoPoint.longitude)")
          
                let interestedInWomen = NCMBUser.current().object(forKey: "interestedInWomen") as! Bool
                // クエリ作成
                let query2 = NCMBQuery(className: "user")
//                query2!.whereKey("geopoint", nearGeoPoint:currentGeoPoint, withinKilometers: 1.0)
                // 探している性別に合わせ検索条件変更
//                if interestedInWomen == true {
//                    query2!.whereKey("gender", equalTo: "male")
//                } else {
//                    query2!.whereKey("gender", equalTo: "female")
//                }
//
                // 取得件数は1件
                query2!.limit = 1
                // アクションした人は対象外
                var ignoredUsers = [""]
                
                for object in objects! {
                    let action = object as! NCMBObject
                    let user = action.object(forKey: "to")
                    print("to user:\(user)")
                    ignoredUsers.append((object as AnyObject).objectId as String)
                }
                print("ignoredUsers:\(ignoredUsers)")
                query2!.whereKey("objectId", notContainedInArrayTo: ignoredUsers)
                query2!.findObjectsInBackground({(objects, error) in
                    if (error != nil){
                        print("友達取得失敗:\(error)")
                    } else {
                        print("友達取得成功:\(objects)")
                        if objects!.count > 0 {
                            self.displayedUser = objects![0] as! NCMBUser
                            let fbPictureUrl = "https://3.bp.blogspot.com/-esJ3eqpx3Vc/XMZ94CFpjHI/AAAAAAABSmE/eJFVEHwpty0fxzrsX_Pmtw89nvUDxQt_QCLcBGAs/s800/ishiki_hikui_man.png"
                           
                            if let fbpicUrl = NSURL(string: fbPictureUrl) {
                                if let data = NSData(contentsOf: fbpicUrl as URL) {
                                    self.userImageView.image = UIImage(data: data as Data)
                                }
                            }
                        } else {
                            // 画像を初期化
                            self.userImageView.image = UIImage()
                            self.userImageView.isUserInteractionEnabled = false
                        }
                    }
                })
            }
        })
    }
    
    @objc func wasDragged(gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translation(in: self.view)
        
        let imageView = gesture.view!
        
        imageView.center = CGPoint(
            x: self.view.bounds.width / 2 + translation.x,
            y: self.view.bounds.height / 2 + translation.y
        )
        // 中央からのX軸移動量取得
        let xFromCenter = imageView.center.x - self.view.bounds.width / 2
        // X軸移動量から縮小率算出
        let scale = min(100 / abs(xFromCenter), 1)
        // X軸移動量から回転率算出
        var rotation = CGAffineTransform(rotationAngle: xFromCenter / 200)
        // 回転・縮小の値をセット
        var stretch = rotation.scaledBy(x: scale, y: scale)
        // Viewを回転・縮小
        imageView.transform = stretch
        // ドラッグ完了時X軸が100p以上移動していたらDB登録して次のユーザ表示
        if gesture.state == UIGestureRecognizer.State.ended {
            var acceptedOrRejected = ""
            if imageView.center.x < 100 {
                print("rejected")
                acceptedOrRejected = "rejected"
            } else if imageView.center.x > self.view.bounds.width - 100 {
                print("accepted")
                acceptedOrRejected = "accepted"
            }
            print("好みの相手判断:\(acceptedOrRejected)")
            if acceptedOrRejected != "" {

                let action = NCMBObject(className: "Action")
                action!.setObject(NCMBUser.current(), forKey: "from")
                action!.setObject(self.displayedUser, forKey: "to")
                action!.setObject(acceptedOrRejected, forKey: "acceptedOrRejected")
                let acl = NCMBACL()
                acl.setPublicReadAccess(true)
                action!.acl = acl
                action!.saveInBackground({(error) in
                    if error != nil{
                        print("Actionテーブル保存失敗:\(error)")
                    } else {
                        print("Actionテーブル保存成功:\(action)")
                        self.fetchUser()
                    }
                })
            }
            rotation = CGAffineTransform(rotationAngle: 0)
            stretch = rotation.scaledBy(x: 1, y: 1)
            imageView.transform = stretch
            imageView.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)
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

}

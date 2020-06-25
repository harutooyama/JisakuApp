//
//  ViewController.swift
//  PhotoShare
//
//  Created by Owner on 2020/06/12.
//  Copyright © 2020 asOne. All rights reserved.
//

import UIKit
import NCMB

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var photos = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "TimeLineCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TimeLineCollectionViewCell")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
        self.loginCheck()
    }
    
    func loginCheck() {
        if NCMBUser.current() != nil {
            print("ログイン済み")
            self.fetchPhotos()
        } else {
            print("未ログイン")
            self.performSegue(withIdentifier: "toLogin", sender: nil)
        }
    }

    @IBAction func logoutButtonTapped(_ sender: Any) {
        NCMBUser.logOut()
        self.loginCheck()
    }
    
    func fetchPhotos() {
        photos = NSMutableArray()
        
        let friendQuery = NCMBQuery(className: "FriendRequest")
        friendQuery?.whereKey("from", equalTo: NCMBUser.current())
        friendQuery?.whereKey("status", equalTo: "accepted")
        
        let photoQueryA = NCMBQuery(className: "Photo")
        photoQueryA?.whereKey("owner", matchesKey: "to", in: friendQuery)
        
        let photoQueryB = NCMBQuery(className: "Photo")
        photoQueryB?.whereKey("owner", equalTo: NCMBUser.current())
        
        let query = NCMBQuery.orQuery(withSubqueries: [photoQueryA, photoQueryB])
        query?.findObjectsInBackground({(objects, error) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if error != nil {
                print("画像データ取得失敗:\(error)")
            } else {
                print("画像データ取得成功:\(objects)")
                for photo in objects! {
                    let filename = (photo as AnyObject).object(forKey: "filename") as! String
                    self.photos.addObjects(from: [photo])
                }
                self.collectionView.reloadData()
            }
        })
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeLineCollectionViewCell", for: indexPath) as! TimeLineCollectionViewCell
        let photo = photos.object(at: indexPath.row) as! NCMBObject
        let user = photo.object(forKey: "owner") as! NCMBUser
        cell.userIdLabel.text = user.userName
        cell.postDateLabel.text = photo.object(forKey: "createDate") as? String
        
        if cell.imageView?.image == nil {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            let fileData = NCMBFile.file(withName: photo.object(forKey: "filename") as! String, data: nil) as! NCMBFile
            fileData.getDataInBackground({(imageData, error) -> Void in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                if error != nil {
                    print("写真の取得失敗\(error)")
                } else {
                    cell.imageView?.image = UIImage(data: imageData!)
                    cell.layoutSubviews()
                }
            })
        }
        
        fetchNumberOfLike(photo: photo, index: indexPath as NSIndexPath)
        cell.likeButton.addTarget(self, action: #selector(ViewController.checkButtonTapped(sender:)), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = self.view.frame.width
        return CGSize(width: size, height: size + 70)
    }
    
    @objc func checkButtonTapped(sender: UIButton) {
        let buttonPosition = sender.convert(CGPoint.zero, to: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: buttonPosition)
        
        if indexPath != nil {
            print(indexPath!.row)
            let photo = photos.object(at: indexPath!.row) as! NCMBObject
            addLike(photo: photo, index: indexPath as! NSIndexPath)
        }
    }
    
    func addLike(photo: NCMBObject, index: NSIndexPath) {
        let like = NCMBObject(className: "Like")
        like?.setObject(NCMBUser.current(), forKey: "user")
        like?.setObject(photo, forKey: "photo")
        like?.saveInBackground({(error) in
            if error != nil {
                print("いいね保存失敗:\(error)")
            } else {
                print("いいね保存成功")
                let cell = self.collectionView.cellForItem(at: index as IndexPath) as! TimeLineCollectionViewCell
                cell.likeButton.isEnabled = false
                self.fetchNumberOfLike(photo: photo, index: index)
            }
        })
    }
    
    func fetchNumberOfLike(photo: NCMBObject, index: NSIndexPath) {
        let query = NCMBQuery(className: "Like")
        query?.whereKey("photo", equalTo: photo)
        query?.findObjectsInBackground({(objects, error) in
            if error != nil {
                print("いいね数取得失敗:\(error)")
            } else {
                print("いいね数取得成功:\(objects?.count)")
                let cell = self.collectionView.cellForItem(at: index as IndexPath) as! TimeLineCollectionViewCell
            }
        })
    }
    
}


//
//  ImagePostViewController.swift
//  PhotoShare
//
//  Created by Owner on 2020/06/12.
//  Copyright © 2020 asOne. All rights reserved.
//

import UIKit
import NCMB

class ImagePostViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var pickedImage:UIImage!
    var imageFile:NCMBFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.imageView.image = pickedImage
        self.imageView.contentMode = UIView.ContentMode.scaleAspectFit
    }
    
    @IBAction func postButtonTapped(_ sender: Any) {
        postImageToNCMB()
    }
    
    func postImageToNCMB() {
        let resizedImage = self.resizedImage(image: pickedImage, ratio: 0.1)
        let imageData = NSData(data: resizedImage.pngData()!) as NSData
        let filename = "\(NSUUID().uuidString).png"
        imageFile = NCMBFile.file(withName: filename, data: imageData as Data) as! NCMBFile
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        imageFile.saveInBackground({(error) in
            if error != nil {
                print("写真保存失敗:\(error)")
            } else {
                print("写真保存成功")
                let imageMeta = NCMBObject(className: "Photo")
                imageMeta?.setObject(filename, forKey: "filename")
                imageMeta?.setObject(NCMBUser.current(), forKey: "owner")
                imageMeta?.saveInBackground({(error) in
                    if error != nil {
                        print("写真メタ保存失敗:\(error)")
                    } else {
                        print("写真メタ保存成功")
                        let alert = UIAlertController(title: "写真アップロード完了", message: "写真のアップロード完了しました。", preferredStyle: .alert)
                        let action = UIAlertAction(title: "OK", style: .default, handler: {(action: UIAlertAction) -> Void in
                            self.navigationController?.popViewController(animated: true)
                        })
                        alert.addAction(action)
                        self.present(alert, animated: true, completion: nil)
                    }
                })
            }
        }, progressBlock: {(percentDone: Int32) -> Void in
            print("upload status:\(percentDone)")
        })
    }
    
    func resizedImage(image: UIImage, ratio: CGFloat) -> UIImage {
        let size = CGSize(width: image.size.width * ratio, height: image.size.height * ratio)
        UIGraphicsBeginImageContext(size)
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage!
    }
    
}

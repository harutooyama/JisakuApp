//
//  StampSelectViewController.swift
//  StampCamera
//
//  Created by Owner on 2020/06/11.
//  Copyright © 2020 Owner. All rights reserved.
//

import UIKit

class StampSelectViewController: UIViewController ,UICollectionViewDataSource, UICollectionViewDelegate {
    var imageArray:[UIImage] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 1...6{
            imageArray.append(UIImage(named: "\(i).png")!)
        }
        // Do any additional setup after loading the view.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath)
        
        let imageView = cell.viewWithTag(1) as! UIImageView
        
        imageView.image = imageArray[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        let stamp = Stamp()
        stamp.image = imageArray[indexPath.row]
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.stampArray.append(stamp)
        appDelegate.isNewStampAdded = true
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    
    @IBAction func closeTapped(){
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

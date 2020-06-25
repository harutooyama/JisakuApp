//
//  ImagePickerViewController.swift
//  PhotoShare
//
//  Created by Owner on 2020/06/12.
//  Copyright © 2020 asOne. All rights reserved.
//

import UIKit

class ImagePickerViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var pickedImage = UIImage()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func pickImageFromCamera(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let controller = UIImagePickerController()
            controller.delegate = self
            controller.sourceType = UIImagePickerController.SourceType.camera
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    @IBAction func pickImageFromLibrary(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            let controller = UIImagePickerController()
            controller.delegate = self
            controller.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if info[UIImagePickerController.InfoKey.originalImage] != nil {
            pickedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            performSegue(withIdentifier: "toPostImage", sender: nil)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPostImage" {
            let vc = segue.destination as! ImagePostViewController
            vc.pickedImage = self.pickedImage
        }
    }
    
}

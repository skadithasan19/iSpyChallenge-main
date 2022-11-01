//
//  NewChallengeController.swift
//  iSpyChallenge
//
//  Created by Adit Hasan on 10/29/22.
//

import UIKit
import Photos
import SwiftUI
class NewChallengeController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func PhotoPickerAction(_ sender: UIButton) {
        if sender.tag == 0 {
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { [weak self] response in
                if response {
                    DispatchQueue.main.async { self?.openCamera() }
                } else {
                    print("Video access Not granted")
                }
            }
        } else {
            PHPhotoLibrary.requestAuthorization({ [weak self] status in
                if status == .authorized {
                    DispatchQueue.main.async { self?.openGallery() }
                } else {
                    print("Not authorized")
                }
            })
        }
    }

    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    
    func openGallery() {
       if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
           let imagePicker = UIImagePickerController()
           imagePicker.delegate = self
           imagePicker.allowsEditing = true
           imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
           self.present(imagePicker, animated: true, completion: nil)
       }
       else
       {
           let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
           self.present(alert, animated: true, completion: nil)
       }
   }
}

extension NewChallengeController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo
                               info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) { [weak self] in
            self?.performSegue(withIdentifier: "confirmSeque", sender: info)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        injectProperties(viewController: segue.destination, sender: sender as Any)
    }
    
    private func injectProperties(viewController: UIViewController, sender: Any) {
        if let vc = viewController as? ConfirmChallengeController {
            guard let info = sender as? [UIImagePickerController.InfoKey : Any] else { return }
            vc.imageInfo = info
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
}

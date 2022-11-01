//
//  ConfirmChallengeController.swift
//  iSpyChallenge
//
//  Created by Adit Hasan on 10/29/22.
//

import UIKit
import Photos
import Combine
class ConfirmChallengeController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var hintsText: UITextField!
    private var cancelable: AnyCancellable?
    
    private var viewModel: ConfirmChallengeViewModel!
    var imageInfo: [UIImagePickerController.InfoKey : Any]?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ConfirmChallengeViewModel(asset: imageInfo?[.phAsset] as? PHAsset)
        hintsText.delegate = self
        imageView.image = imageInfo?[.originalImage] as? UIImage
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func save(_ sender: UIButton) {
        guard let image = imageInfo?[.originalImage] as? UIImage,
              let imageData = image.jpegData(compressionQuality: 1.0) else { return }
        guard let inputText = hintsText.text, !inputText.isEmpty else {
            print("Hints cannot be empty")
            return
        }
        
        viewModel.saveInformation(imageData: imageData, hints: inputText)
        navigationController?.popToRootViewController(animated: true)
        tabBarController?.selectedIndex = 0
    }
}

extension ConfirmChallengeController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}

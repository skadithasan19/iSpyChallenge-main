//
//  NearMeDetailController.swift
//  iSpyChallenge
//
//  Created by Adit Hasan on 10/29/22.
//

import UIKit

class NearMeDetailController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    var challenge: CDChallenge?
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let photoImageName = challenge?.photoImageName else { return }
        
        if let image = UIImage(named: photoImageName) {
            imageView.image = image
        } else {
            imageView.loadImageFromDiskWith(fileName: photoImageName)
        }
    }
}

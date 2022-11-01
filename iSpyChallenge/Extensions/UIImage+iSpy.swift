//
//  UIImage+iSpy.swift
//  iSpyChallenge
//
//  Created by Adit Hasan on 10/29/22.
//

import Foundation
import UIKit

extension UIImageView {
    func loadImageFromDiskWith(fileName: String) {
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        if let dirPath = paths.first {
            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
            let image = UIImage(contentsOfFile: imageUrl.path)
            self.image = image
        }
    }
}

//
//  ConfirmChallengeViewModelTest.swift
//  iSpyChallengeTests
//
//  Created by Adit Hasan on 10/30/22.
//

import XCTest
import Photos

@testable import iSpyChallenge

final class ConfirmChallengeViewModelTest: XCTestCase {

    func testPHAsset() {
        let options = PHFetchOptions()
        options.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: false)
        ]

        options.predicate = NSPredicate(format: "(mediaSubtype & %d) != 0", PHAssetMediaSubtype.photoLive.rawValue)
        let asset = PHAsset.fetchAssets(with: options).firstObject
        
        let viewModel = ConfirmChallengeViewModel(asset: asset)
        
        XCTAssert(!viewModel.getFileName(assetDate: asset?.creationDate ?? Date()).isEmpty)
        
        guard let image = UIImage(named: "alcatraz-island"),
              let imageData = image.jpegData(compressionQuality: 1.0) else { return }

        XCTAssert(viewModel.saveToDocuments(data: imageData))
        
    }

}

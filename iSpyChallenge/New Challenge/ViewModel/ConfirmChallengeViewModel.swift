//
//  ConfirmChallengeViewModel.swift
//  iSpyChallenge
//
//  Created by Adit Hasan on 10/30/22.
//

import Foundation
import Photos

class ConfirmChallengeViewModel: ObservableObject {
    
    private let coreDataManager: CoreDataManager
    private let asset: PHAsset?
    
    private lazy var apiLocation: APILocation = {
        guard let coordinate = asset?.location?.coordinate else {
            let coordinate = LocationManager.shared.userLocation.coordinate
            return APILocation(latitude: coordinate.latitude,
                               longitude: coordinate.longitude)
        }
        return APILocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }()
    
    private lazy var fileName: String = {
        return getFileName(assetDate: asset?.creationDate ?? Date())
    }()
    
    init(coreDataManager: CoreDataManager = .sharedManager,
         asset: PHAsset?) {
        self.coreDataManager = coreDataManager
        self.asset = asset
    }
    
    func saveInformation(imageData: Data, hints: String) {
        if saveToDocuments(data: imageData) {
            let challenges = coreDataManager.allChallenges()
            guard let lastID = challenges.compactMap({ Int($0.id ?? "0") ?? 0 }).max() else { return }
            print(lastID)
            let challange = Challenge(id: "\(lastID + 1)",
                                      hint: hints,
                                      latitude: apiLocation.latitude,
                                      longitude: apiLocation.longitude,
                                      photoImageName: fileName,
                                      creatorID: "4")
            let user = User(id: "4", email: "example@domain.com", username: "example", challenges: [challange]) /// Hard coding it for now
            _ = CoreDataManager.sharedManager.insert(user: user)
        }
    }
    
    func saveToDocuments(data: Data) -> Bool {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return false }
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("Removed old image")
            } catch let removeError {
                print("couldn't remove file at path", removeError)
            }
        }
        
        do {
            try data.write(to: fileURL)
            return true
        } catch let error {
            print("error saving file with error", error)
            return false
        }
    }
    
    func getFileName(assetDate: Date) -> String {
        let formater = DateFormatter()
        formater.dateStyle = .long
        formater.timeStyle = .long
        guard let dateName = formater.string(from: assetDate).removingPercentEncoding else { return "" }
        let fileName = dateName.replacingOccurrences(of: " ", with: "_") + ".jpg"
        return fileName
    }
}

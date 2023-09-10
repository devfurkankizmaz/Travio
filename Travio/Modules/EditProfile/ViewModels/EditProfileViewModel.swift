//
//  EditProfileViewModel.swift
//  Travio
//
//  Created by Muhammet on 6.09.2023.
//

import Foundation
import Alamofire
import UIKit


class EditProfileViewModel {
    
    typealias UploadImageHandler = (Bool) -> Void
    typealias getProfileHandler = (Bool) -> Void
    
    var profileInfos: Profile?
    public var urls: [String] = []
    
    func uploadImage(images: [UIImage]?, callback: @escaping UploadImageHandler) {
        var imagesData: [Data] = []
        guard let images = images, !images.isEmpty else {
            callback(true)
            return
        }

        images.forEach { image in
            guard let imageData = image.convertToData(withFormat: .jpeg(compressionQuality: 0.8)) else {
                print("Convert err.")
                return
            }
            imagesData.append(imageData)
        }

        NetworkManager.shared.uploadImage(TravioRouter.uploadImage(imageData: imagesData), responseType: UploadResponse.self) { result in
            switch result {
            case .success(let response):
                print("Image uploaded successfully. URLs: \(response.urls)")
                self.urls = response.urls
                callback(true)
            case .failure(let error):
                print("Error uploading image: \(error)")
                callback(true)
            }
        }
    }
    
    func getProfile(callback: @escaping getProfileHandler) {
        NetworkManager.shared.request(TravioRouter.getProfileInfo, responseType: Profile.self) { result in
            switch result {
            case .success(let response):
                print(response)
                self.profileInfos = response
                callback(true)
            case .failure(let error):
                print(error)
                callback(false)
            }
        }
    }
    
    func putEditProfile(name: String, email: String, ppUrl: String) {
        NetworkManager.shared.request(TravioRouter.putEditProfile(params: ["full_name": name, "email": email, "pp_url": ppUrl]), responseType: ResponseModel.self) { result in
            switch result {
            case .success(let response):
                print("Edit profile \(response)")
            case .failure(let error):
                print("Edit profile Error: \(error.localizedDescription)")
            }
        }
    }
}
    

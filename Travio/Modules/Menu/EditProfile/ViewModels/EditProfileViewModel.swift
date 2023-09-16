//
//  EditProfileViewModel.swift
//  Travio
//
//  Created by Furkan Kızmaz on 7.09.2023.
//

import Alamofire
import UIKit

class EditProfileViewModel {
    typealias CompletionHandler = (Bool) -> Void

    var ppUrl: String?

    func saveProfile(image: UIImage?, input: ProfileInput, callback: @escaping CompletionHandler) {
        var updatedInput = input
        if let image = image {
            uploadImage(image: image) { [weak self] success in
                if success, let imageUrl = self?.ppUrl {
                    updatedInput.ppUrl = imageUrl
                }

                self?.editProfile(input: updatedInput, callback: callback)
            }
        } else {
            editProfile(input: updatedInput, callback: callback)
        }
    }

    private func editProfile(input: ProfileInput, callback: @escaping CompletionHandler) {
        let params: Parameters = ["full_name": input.fullName, "email": input.email, "pp_url": input.ppUrl]
        NetworkManager.shared.request(TravioRouter.putEditProfile(params: params), responseType: ResponseModel.self) { result in
            switch result {
            case .success:
                callback(true)
            case .failure:
                callback(false)
            }
        }
    }

    private func uploadImage(image: UIImage?, callback: @escaping CompletionHandler) {
        guard let image = image else {
            callback(false)
            return
        }

        guard let imageData = image.convertToData(withFormat: .jpeg(compressionQuality: 0.8)) else {
            callback(false)
            return
        }

        NetworkManager.shared.uploadImage(TravioRouter.uploadImage(imageData: [imageData]), responseType: UploadResponse.self) { result in
            switch result {
            case .success(let response):
                self.ppUrl = response.urls.first
                callback(true)
            case .failure:
                callback(false)
            }
        }
    }
}

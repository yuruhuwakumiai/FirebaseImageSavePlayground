//
//  FirebaseStorageRepository.swift
//  ImageSaveSampleApp
//
//  Created by 橋元雄太郎 on 2023/12/13.
//

import SwiftUI
import FirebaseStorage

class FirebaseStorageRepository {
    private let storageRef = Storage.storage().reference()

    func uploadImageData(_ imageData: Data, completion: @escaping (Result<String, Error>) -> Void) {
        let imageId = UUID().uuidString
        let imageRef = storageRef.child("images/\(imageId).jpg")

        imageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            imageRef.downloadURL { url, error in
                if let url = url {
                    completion(.success(url.absoluteString))
                } else if let error = error {
                    completion(.failure(error))
                }
            }
        }
    }
}

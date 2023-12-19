//
//  FirebaseStorageRepository.swift
//  ImageSaveSampleApp
//
//  Created by 橋元雄太郎 on 2023/12/13.
//

import SwiftUI
import FirebaseStorage

class FirebaseStorageRepository {
    private let storageRef = Storage.storage().reference(forURL: "gs://imagesavesampleapp.appspot.com")

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

    func fetchImageURLs(completion: @escaping (Result<[String], Error>) -> Void) {
        storageRef.child("images").listAll { (result, error) in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let result = result else {
                completion(.failure(NSError(domain: "FirebaseStorageError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No result found"])))
                return
            }

            let group = DispatchGroup()
            var urls: [String] = []

            for item in result.items {
                group.enter()
                item.downloadURL { url, error in
                    if let url = url {
                        urls.append(url.absoluteString)
                    }
                    group.leave()
                }
            }

            group.notify(queue: .main) {
                completion(.success(urls))
            }
        }
    }

}


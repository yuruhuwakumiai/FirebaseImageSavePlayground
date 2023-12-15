//
//  Model.swift
//  ImageSaveSampleApp
//
//  Created by 橋元雄太郎 on 2023/12/13.
//

import SwiftUI
import FirebaseStorage

struct Ramen: Identifiable {
    var id = UUID() // 自動生成される一意のID
    var name: String
    var shop: String
    var rating: Int
    var imageUrl: String? // Firebase Storageから取得した画像のURL（まだ画像がない場合はnil）
}


struct RamenModel {
    // インスタンスしてリポジトリを使用する
    private var firebaseStorageRepository = FirebaseStorageRepository()
    private(set) var ramens: [Ramen] = []

    // MARK: 変数はここに追加
    var isPresentingAddView = false
    var showImagePicker = false
    var selectedImageData: Data?

    // MARK: 関数はここに追加
    // Firebase Storageに画像データをアップロードし、URLを取得する
    mutating func uploadImage(_ imageData: Data, completion: @escaping (Result<String, Error>) -> Void) {
        firebaseStorageRepository.uploadImageData(imageData, completion: completion)
    }

    // 新しいラーメンのインスタンスを作成し、リストに追加する
    mutating func addRamen(name: String, shop: String, rating: Int, imageUrl: String? = nil) {
        let newRamen = Ramen(name: name, shop: shop, rating: rating, imageUrl: imageUrl)
        ramens.append(newRamen)
    }

    // リストから特定のラーメンを削除する
    // IndexSetを使って複数の要素を削除することも可能
    mutating func removeRamens(at offsets: IndexSet) {
        ramens.remove(atOffsets: offsets)
    }

    // ラーメン追加ビューの表示状態を切り替える
    // isPresentingAddViewの状態をトグルする（true⇔false）
    mutating func toggleAddRamenView() {
        isPresentingAddView.toggle()
    }
}

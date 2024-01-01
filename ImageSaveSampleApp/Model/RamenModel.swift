//
//  RamenModel.swift
//  ImageSaveSampleApp
//
//  Created by 橋元雄太郎 on 2023/12/13.
//

import SwiftUI

struct RamenModel {
    // firebaseをインスタンスしてリポジトリを使用する
    private var firebaseStorageRepository = FirebaseStorageRepository()
    private(set) var ramens: [Ramen] = []

    // MARK: 変数はここに追加
    var isPresentingAddView = false
    var showImagePicker = false
    var selectedImageData: Data?
    // アップロード完了の状態を示すプロパティ
    var isUploadCompleted = false
    // アップロードされた時のメッセージを出すフラグ
    var isShowAlert = false

    // MARK: 関数はここに追加
    /// Firebase Storageに画像データをアップロードし、URLを取得する
    mutating func uploadImage(_ imageData: Data, completion: @escaping (Result<String, Error>) -> Void) {
        firebaseStorageRepository.uploadImageData(imageData, completion: completion)
    }

    /// 新しいラーメンのインスタンスを作成し、リストに追加する
    /// TODO: ここname、shop、rating、imageUrlひとつひとつもらっているが、ViewModel側で、Ramen型を作成して、Ramen型で受け取れば良いのでは？
    mutating func addRamen(name: String, shop: String, rating: Int, imageUrl: String? = nil) {
        let newRamen = Ramen(name: name, shop: shop, rating: rating, imageUrl: imageUrl)
        ramens.append(newRamen)
    }

    // リストから特定のラーメンを削除する
    /// IndexSetを使って複数の要素を削除することも可能
    mutating func removeRamens(at offsets: IndexSet) {
        ramens.remove(atOffsets: offsets)
    }

    // ラーメン追加ビューの表示状態を切り替える
    /// isPresentingAddViewの状態をトグルする（true⇔false）
    mutating func toggleAddRamenView() {
        isPresentingAddView.toggle()
    }

    mutating func toggleShowImagePicker() {
        showImagePicker = true
    }

    mutating func toggleIsShowAlert() {
        isShowAlert = true
    }
}

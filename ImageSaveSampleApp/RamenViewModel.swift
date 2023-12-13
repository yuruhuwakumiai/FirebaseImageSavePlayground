//
//  RamenViewModel.swift
//  ImageSaveSampleApp
//
//  Created by 橋元雄太郎 on 2023/12/13.
//

import SwiftUI

class RamenViewModel: ObservableObject {
    @Published private var model = RamenModel()

    // ラーメンのリストをビューに提供する
    var ramens: [Ramen] {
        model.ramens
    }

    // ラーメン追加ビューの表示状態をビューに提供する
    var isPresentingAddView: Bool {
        get { model.isPresentingAddView }
        set { model.isPresentingAddView = newValue }
    }

    var showImagePicker: Bool {
        get { model.showImagePicker }
        set { model.showImagePicker = newValue }
    }

    // 選択された画像データにアクセスするためのコンピューテッドプロパティ
    var selectedImageData: Data? {
        get { model.selectedImageData }
        set { model.selectedImageData = newValue }
    }

    // ユーザーが選択した画像データを受け取り、Firebase Storageにアップロードする
    // RamenViewModel内
    func uploadImage() {
        guard let imageData = model.selectedImageData else { return }

        model.uploadImage(imageData) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let url):
                    self?.handleImageUploadSuccess(url)
                case .failure(let error):
                    self?.handleImageUploadFailure(error)
                }
                self?.model.selectedImageData = nil
            }
        }
    }

    private func handleImageUploadSuccess(_ imageUrl: String) {
        // ここでラーメンのデータに画像URLを追加
        model.addRamen(name: "New Ramen", shop: "Ramen Shop", rating: 5, imageUrl: imageUrl)
    }

    // アップロード失敗時の処理
    private func handleImageUploadFailure(_ error: Error) {
        print("Image upload failed: \(error.localizedDescription)")
        // 必要に応じてエラー処理を行います。例えば、ユーザーにエラーメッセージを表示するなどです。
    }

    // ラーメンのデータを追加する
    func addRamen(name: String, shop: String, rating: Int) {
        model.addRamen(name: name, shop: shop, rating: rating, imageUrl: nil) // 画像URLは後でアップロード成功時にセット
    }

    // 特定のラーメンをリストから削除する
    func removeRamen(at offsets: IndexSet) {
        model.removeRamens(at: offsets)
    }

    // ラーメン追加ビューの表示状態を切り替える
    func toggleAddRamenView() {
        model.toggleAddRamenView()
    }
}

//
//  RamenViewModel.swift
//  ImageSaveSampleApp
//
//  Created by 橋元雄太郎 on 2023/12/13.
//

import SwiftUI

class RamenViewModel: ObservableObject {
    @Published private var model = RamenModel()

    // ラーメンのリストをビューに提供するプロパティ
    var ramens: [Ramen] {
        model.ramens
    }

    // ラーメン追加ビューの表示状態を管理するプロパティ
    var isPresentingAddView: Bool {
        get { model.isPresentingAddView }
        set { model.isPresentingAddView = newValue }
    }

    // 画像選択ピッカーの表示状態を管理するプロパティ
    var showImagePicker: Bool {
        get { model.showImagePicker }
        set { model.showImagePicker = newValue }
    }

    // 選択された画像データにアクセスするプロパティ
    var selectedImageData: Data? {
        get { model.selectedImageData }
        set { model.selectedImageData = newValue }
    }

    // 選択された画像をFirebase Storageにアップロードするメソッド
    func uploadImage() {
        guard let imageData = model.selectedImageData else { return }

        model.uploadImage(imageData) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let url):
                    // アップロード成功時に画像URLを含む新しいRamenインスタンスを追加
                    self?.addRamenWithImage(url: url)
                case .failure(let error):
                    // アップロード失敗時のエラー処理
                    self?.handleError(error)
                }
            }
        }
    }

    // アップロードされた画像URLを含む新しいRamenインスタンスを追加するメソッド
    private func addRamenWithImage(url: String) {
        addRamen(name: "New Ramen", shop: "Ramen Shop", rating: 5, imageUrl: url)
    }

    // アップロードやその他の処理で発生したエラーを処理するメソッド
    private func handleError(_ error: Error) {
        // ここにエラー処理のロジックを実装
    }

    // 新しいRamenインスタンスを追加するメソッド
    func addRamen(name: String, shop: String, rating: Int, imageUrl: String? = nil) {
        model.addRamen(name: name, shop: shop, rating: rating, imageUrl: imageUrl)
    }

    // 特定のRamenインスタンスをリストから削除するメソッド
    func removeRamen(at offsets: IndexSet) {
        model.removeRamens(at: offsets)
    }

    // ラーメン追加ビューの表示状態を切り替えるメソッド
    func toggleAddRamenView() {
        model.toggleAddRamenView()
    }
}


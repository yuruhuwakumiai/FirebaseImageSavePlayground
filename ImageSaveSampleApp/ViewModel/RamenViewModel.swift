//
//  RamenViewModel.swift
//  ImageSaveSampleApp
//
//  Created by 橋元雄太郎 on 2023/12/13.
//

import SwiftUI

class RamenViewModel: ObservableObject {
    @Published private var model = RamenModel()

    // MARK: ここでプロパティを連携させる
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

    // アップロード完了の状態をビューに提供するプロパティ
    var isUploadCompleted: Bool {
        get { model.isUploadCompleted }
        set { model.isUploadCompleted = newValue }
    }

    // アップロードされた時のアラートを出す変数
    var showAlert: Bool {
        get { model.showAlert }
        set { model.showAlert = newValue }
    }

    // 選択された画像をFirebase Storageにアップロードするメソッド
    // 画像アップロードのメソッド（更新）
    func uploadImage() {
        guard let imageData = selectedImageData else { return }

        model.uploadImage(imageData) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let url):
                    // 成功時の処理
                    self?.addRamenWithImage(url: url)
                case .failure(let error):
                    // 失敗時の処理
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


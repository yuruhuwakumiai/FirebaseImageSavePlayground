//
//  RamenViewModel.swift
//  ImageSaveSampleApp
//
//  Created by 橋元雄太郎 on 2023/12/13.
//

import SwiftUI

class RamenViewModel: ObservableObject {
    @Published private var model = RamenModel()

    /// ラーメンのリストをビューに提供するプロパティ
    var ramens: [Ramen] { model.ramens }
    
    var uploadImageButtonDisabled: Bool {
        return selectedImageData == nil
    }

    /// ラーメン追加ビューの表示状態を管理するプロパティ
    var isPresentingAddView: Bool {
        get { model.isPresentingAddView }
        set { model.isPresentingAddView = newValue }
    }

    /// 画像選択ピッカーの表示状態を管理するプロパティ
    var showImagePicker: Bool {
        get { model.showImagePicker }
        set { model.showImagePicker = newValue }
    }

    /// 選択された画像データにアクセスするプロパティ
    var selectedImageData: Data? {
        get { model.selectedImageData }
        set { model.selectedImageData = newValue }
    }

    /// アップロード完了の状態をビューに提供するプロパティ
    var isUploadCompleted: Bool {
        get { model.isUploadCompleted }
        set { model.isUploadCompleted = newValue }
    }

    /// アップロードされた時のアラートを出す変数
    var showAlert: Bool {
        get { model.showAlert }
        set { model.showAlert = newValue }
    }

    /// 選択された画像をFirebase Storageにアップロードするメソッド
    /// 画像アップロードのメソッド（更新）
    /// 画像アップロードのメソッド
    func uploadImage() {
        guard let imageData = selectedImageData else { return }

        model.uploadImage(imageData) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let url):
                    self?.addRamenWithImage(url: url)
                case .failure(let error):
                    self?.handleError(error)
                }
            }
        }
    }

    /// アップロードされた画像URLを含む新しいRamenインスタンスを追加するメソッド
    private func addRamenWithImage(url: String) {
        // ここで 'name' と 'shop' に実際の値を設定する
        addRamen(imageUrl: url)
        model.toggleShowAlert()
    }

    /// アップロードやその他の処理で発生したエラーを処理するメソッド
    private func handleError(_ error: Error) {
        // ここにエラー処理のロジックを実装
    }

    /// 新しいRamenインスタンスを追加するメソッド
    private func addRamen(
        name: String = "New Ramen",
        shop: String = "Ramen Shop",
        rating: Int = 5,
        imageUrl: String? = nil
    ) {
        model.addRamen(name: name, shop: shop, rating: rating, imageUrl: imageUrl)
    }

    /// 特定のRamenインスタンスをリストから削除するメソッド
    private func removeRamen(at offsets: IndexSet) {
        model.removeRamens(at: offsets)
    }

    /// ラーメン追加ビューの表示状態を切り替えるメソッド
    func toggleAddRamenView() {
        model.toggleAddRamenView()
    }
    
    func toggleShowImagePicker() {
        model.toggleShowImagePicker()
    }
}


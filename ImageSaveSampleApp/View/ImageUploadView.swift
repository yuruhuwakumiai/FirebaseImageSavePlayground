//
//  ImageUploadView.swift
//  ImageSaveSampleApp
//
//  Created by 橋元雄太郎 on 2023/12/13.
//

import SwiftUI
import FirebaseStorage

// IMO: - 私なら、Viewで分けずに、ViewBuilderで分けますね。
struct ImageUploadView: View {
    @StateObject private var viewModel = RamenViewModel()

    var body: some View {
        NavigationStack {
            VStack {
                // 画像が選択されていれば表示、そうでなければプレースホルダーを表示
                if let imageData = viewModel.selectedImageData, 
                    let image = UIImage(data: imageData) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 300)
                } else {
                    Text("画像を選択してください")
                        .frame(height: 300)
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(10)
                }

                // 画像アップロードボタン
                Button("画像をアップロードする") {
                    viewModel.uploadImage()
                }
                .disabled(viewModel.uploadImageButtonDisabled)

                // アップロードされた画像のリスト表示（サンプル）
                List(viewModel.ramens) { ramen in
                    RamenRowView(ramen: ramen)
//                    Text(ramen.name)
                }
            }
            .navigationTitle("画像アップロード")
            // TODO: - この書き方は非推奨。Toolbarを使いましょう。
            .navigationBarItems(trailing: Button("画像を選択") {
                viewModel.toggleShowImagePicker()
            })
            .sheet(isPresented: $viewModel.showImagePicker) {
                ImagePicker(imageData: $viewModel.selectedImageData)
            }
            // アラートの定義
            .alert(isPresented: $viewModel.showAlert) {
                // TODO: - この書き方は非推奨。
                Alert(
                    title: Text("アップロード完了"),
                    message: Text("画像のアップロードが完了しました。"),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}

struct RamenRowView: View {
    let ramen: Ramen
    
    var body: some View {
        if let imageUrl = ramen.imageUrl,
           let url = URL(string: imageUrl) {
            AsyncImage(url: url) { phase in
                if let image = phase.image {
                    image
                        .resizable() // 画像をリサイズ可能にする
                        .scaledToFit() // アスペクト比を維持してフィットさせる
                        .frame(width: 50, height: 50) // 画像のサイズ指定
                        .clipShape(Circle()) // 円形にクリップ
                        .overlay(Circle().stroke(Color.white, lineWidth: 2)) // 白い枠線を追加
                        .shadow(radius: 3) // 影を追加
                } else {
                    emptyStateImageView()
                }
            }
        } else {
            emptyStateImageView()
        }
        // 他のラーメン情報の表示
    }
    
    @ViewBuilder
    private func emptyStateImageView() -> some View {
        Image(systemName: "photo") // URLがない場合のプレースホルダー画像
            .resizable()
            .scaledToFit()
            .frame(width: 50, height: 50)
            .clipShape(Circle())
    }
}

struct ImageUploadView_Previews: PreviewProvider {
    static var previews: some View {
        ImageUploadView()
    }
}

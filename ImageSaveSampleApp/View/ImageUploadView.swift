//
//  ImageUploadView.swift
//  ImageSaveSampleApp
//
//  Created by 橋元雄太郎 on 2023/12/13.
//

import SwiftUI
import FirebaseStorage

struct ImageUploadView: View {
    @StateObject private var viewModel = RamenViewModel()

    var body: some View {
        NavigationStack {
            VStack {
                // 画像が選択されていれば表示、そうでなければプレースホルダーを表示
                if let imageData = viewModel.selectedImageData, let image = UIImage(data: imageData) {
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
                .disabled(viewModel.selectedImageData == nil)

                // アップロードされた画像のリスト表示（サンプル）
                List(viewModel.ramens) { ramen in
                    Text(ramen.name)
                }
            }
            .navigationTitle("画像アップロード")
            .navigationBarItems(trailing: Button("画像を選択") {
                viewModel.showImagePicker = true
            })
            .sheet(isPresented: $viewModel.showImagePicker) {
                ImagePicker(imageData: $viewModel.selectedImageData)
            }
        }
        // アップロード完了時のアラート表示
        .onReceive($viewModel.isUploadCompleted) { completed in
            viewModel.showAlert = completed
        }
        // アラートの定義
        .alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text("アップロード完了"),
                message: Text("画像のアップロードが完了しました。"),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

struct RamenRow: View {
    let ramen: Ramen

    var body: some View {
        HStack {
            if let imageUrl = ramen.imageUrl, let url = URL(string: imageUrl), let imageData = try? Data(contentsOf: url), let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    .shadow(radius: 7)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    .shadow(radius: 7)
            }
            // 他のラーメン情報の表示
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var imageData: Data?

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.imageData = image.jpegData(compressionQuality: 0.5)
            }

            picker.dismiss(animated: true)
        }
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}

struct ImageUploadView_Previews: PreviewProvider {
    static var previews: some View {
        ImageUploadView()
    }
}

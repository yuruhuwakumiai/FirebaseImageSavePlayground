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
    @State private var showPreview = false // 選択した画像のプレビュー表示

    var body: some View {
        NavigationView {
            VStack {
                if let imageData = viewModel.selectedImageData, let image = UIImage(data: imageData) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 300)
                    Button("画像をアップロードする") {
                        viewModel.uploadImage()
                    }
                } else {
                    Text("画像を選択してください")
                }
                Spacer()
            }
            .navigationTitle("画像追加テストApp")
            .navigationBarItems(
                leading: Button(action: {
                    viewModel.showImagePicker = true // 画像選択ピッカーを表示
                }) {
                    Text("画像を選択")
                }
            )
            .sheet(isPresented: $viewModel.showImagePicker) {
                ImagePicker(imageData: $viewModel.selectedImageData)
            }
        }
    }
}


struct RamenRow: View {
    let ramen: Ramen

    var body: some View {
        HStack {
            // Firebase Storageから取得した画像URLを使用して画像を表示
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

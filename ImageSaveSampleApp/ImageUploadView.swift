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
        NavigationView {
            List(viewModel.ramens) { ramen in
                RamenRow(ramen: ramen)
            }
            .navigationTitle("Ramen Tracker")
            .navigationBarItems(
                leading: Button(action: {
                    self.viewModel.showImagePicker = true
                }) {
                    Text("画像を選択")
                },
                trailing: Button(action: {
                    viewModel.toggleAddRamenView()
                }) {
                    Text(viewModel.isPresentingAddView ? "完了" : "追加")
                }
            )
            .sheet(isPresented: $viewModel.showImagePicker, onDismiss: uploadImage) {
                ImagePicker(imageData: $viewModel.selectedImageData)
            }
        }
    }

    private func uploadImage() {
        if let imageData = viewModel.selectedImageData {
            viewModel.uploadImage(imageData)
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
            VStack(alignment: .leading) {
                Text(ramen.name).font(.headline)
                Text(ramen.shop).font(.subheadline)
            }
            Spacer()
            Text("Rating: \(ramen.rating)/5")
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

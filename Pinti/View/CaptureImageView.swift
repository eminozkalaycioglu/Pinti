//
//  CaptureImageView.swift
//  Pinti
//
//  Created by Emin on 2.01.2021.
//

import Foundation
import SwiftUI
import UIKit
struct CaptureImageView {
    @Binding var isShown: Bool
    @Binding var image: UIImage
    
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(isShown: $isShown, image: $image)
    }
}
extension CaptureImageView: UIViewControllerRepresentable {
    func makeUIViewController(context: UIViewControllerRepresentableContext<CaptureImageView>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        
        picker.delegate = context.coordinator
        picker.allowsEditing = true

        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController,
                                context: UIViewControllerRepresentableContext<CaptureImageView>) {
        
    }
    
}

class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @Binding var isCoordinatorShown: Bool
    @Binding var imageInCoordinator: UIImage
    init(isShown: Binding<Bool>, image: Binding<UIImage>) {
        _isCoordinatorShown = isShown
        _imageInCoordinator = image
    }
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.imageInCoordinator = img
        } else if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.imageInCoordinator = img
        }
        isCoordinatorShown = false
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isCoordinatorShown = false
    }
    
    
}



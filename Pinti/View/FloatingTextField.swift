//
//  FloatingTextField.swift
//  Pinti
//
//  Created by Emin on 2.01.2021.
//

import Foundation
import SwiftUI
import UIKit

import MaterialComponents.MaterialTextControls_FilledTextAreas
import MaterialComponents.MaterialTextControls_FilledTextFields
import MaterialComponents.MaterialTextControls_OutlinedTextAreas
import MaterialComponents.MaterialTextControls_OutlinedTextFields

final class FloatingTextField: UIViewRepresentable {
    let label: String
    let placeholder: String
    let defaultValue: String?
    let disabled: Bool
    @Binding var currentText: String?
    let imageName: String?
    let secureText: Bool
    init(currentText: Binding<String?>? = nil, _ label: String, _ placeholder: String, defaultValue: String? = nil, disabled: Bool = false, imageName: String? = nil, secureText: Bool = false) {
        self.label = label
        self.placeholder = placeholder
        self._currentText = currentText ?? Binding(get: {
            return ""
        }, set: { (_) in
        
        })
        self.defaultValue = defaultValue
        self.disabled = disabled
        self.imageName = imageName
        self.secureText = secureText
    }
    
    func makeUIView(context: Context) -> MDCOutlinedTextField {
        let field = MDCOutlinedTextField()
        return field
    }
    
    func updateUIView(_ uiView: MDCOutlinedTextField, context: Context) {
        uiView.label.text = self.label
        if defaultValue != nil {
            uiView.text = defaultValue!
        }
        
        if self.currentText != nil && self.currentText?.count ?? 0 > 1{
            uiView.text = self.currentText

        }
        uiView.isSecureTextEntry = self.secureText
        uiView.placeholder = placeholder
        let vw = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        vw.backgroundColor = .red
        
        if let imageName = self.imageName, var image = UIImage(systemName: imageName) {
            uiView.leadingViewMode = .always
            let imageView = UIImageView(image: image.withRenderingMode(.alwaysTemplate))
            imageView.tintColor = .gray
            imageView.contentMode = .scaleAspectFit
            imageView.frame = CGRect(x: 0, y: 0, width: 35, height: 25)
            uiView.leadingView = imageView
        }
        
        
        
        let gray = UIColor(red: 60/255, green: 60/255, blue: 60/255, alpha: 1)
        let orange = UIColor(red: 255/255, green: 166/255, blue: 0/255, alpha: 1)

        uiView.setOutlineColor(gray.withAlphaComponent(0.6), for: .normal)
        uiView.setOutlineColor(gray.withAlphaComponent(0.6), for: .disabled)
        uiView.setOutlineColor(orange, for: .editing)
        
        uiView.setNormalLabelColor(gray, for: .normal)
        uiView.setNormalLabelColor(gray, for: .disabled)
        uiView.setNormalLabelColor(gray, for: .editing)

        uiView.setFloatingLabelColor(gray, for: .disabled)
        uiView.setFloatingLabelColor(gray, for: .normal)
        uiView.setFloatingLabelColor(orange, for: .editing)
        
        uiView.setTextColor(gray, for: .normal)
        uiView.setTextColor(gray, for: .editing)
        uiView.setTextColor(gray, for: .disabled)
        
        uiView.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)

        uiView.isUserInteractionEnabled = !self.disabled

        uiView.label.font = UIFont(name: "Poppins-SemiBold", size: 14)
        uiView.font = UIFont(name: "Poppins-SemiBold", size: 14)

        
        
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        self.currentText = textField.text
    }
    func makeCoordinator() -> Coordinator {
        return Coordinator(currentText: self.$currentText)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var currentText: String?
        
        init(currentText: Binding<String?>) {
            self._currentText = currentText
        }

        
    }
}



extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

//
//  Views+Extension.swift
//  Pinti
//
//  Created by Emin on 27.12.2020.
//

import Foundation
import SwiftUI
extension Text {
    func poppins(_ font: PoppinsMapper,_ size: CGFloat) -> Text {
        return self.font(.custom(font.rawValue, size: size))
    }
}

enum PoppinsMapper: String {
    case black = "Poppins-Black"
    case bold = "Poppins-Bold"
    case extraBold = "Poppins-ExtraBold"
    case extraLight = "Poppins-ExtraLight"
    case italic = "Poppins-Italic"
    case light = "Poppins-Light"
    case medium = "Poppins-Medium"
    case regular = "Poppins-Regular"
    case semiBold = "Poppins-SemiBold"
    case thin = "Poppins-Thin"
}




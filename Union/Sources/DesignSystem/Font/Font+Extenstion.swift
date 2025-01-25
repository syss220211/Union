//
//  Font+Extenstion.swift
//  Union
//
//  Created by 박서연 on 1/23/25.
//

import SwiftUI
import UIKit

/// 앱에서 사용할 폰트와 스타일을 관리
enum UFont {
    case light
    case regular
    case meduim
    case semibold
    case bold
    
    /// KantumruyPro 폰트
    var font: String {
        switch self {
        case .light:
            return "KantumruyPro-Light"
        case .regular:
            return "KantumruyPro-Regular"
        case .meduim:
            return "KantumruyPro-Medium"
        case .semibold:
            return "KantumruyPro-SemiBold"
        case .bold:
            return "KantumruyPro-Bold"
        }
    }
    
    /// 폰트의 자간 정의
    var letter: CGFloat {
        switch self {
        case .light, .bold, .meduim, .regular, .semibold:
            return -0.03
        }
    }
}

/// 텍스트에 폰트, 줄높이, 자간, 크기등 Typography 스타일을 적용하는 ViewModifer입니다.
struct UfontModifier: ViewModifier {
    
    let font: UFont
    let size: CGFloat
    let lineHeight: CGFloat
    let color: Color
    
    /// - Parameters:
    ///   - font: 폰트 및 굵기, 자간
    ///   - size: 글자 크기
    ///   - lineheight: 글자 높이
    init(
        font: UFont,
        size: CGFloat,
        lineHeight: CGFloat,
        color: Color
    ) {
        self.font = font
        self.size = size
        self.lineHeight = lineHeight
        self.color = color
    }
    
    func body(content: Content) -> some View {
        content
            .padding(.vertical, (lineHeight - size / 2))
            .font(.custom(font.font, size: size))
//            .tracking(font.letter)
            .foregroundStyle(color)
    }
}

/// Typography.FontStyle을 쉽게 적용할 수 있도록 도와줍니다.
extension View {
    func utypograph(
        font: UFont,
        size: CGFloat,
        lineHeight: CGFloat,
        color: Color = .black
    ) -> some View {
        modifier(
            UfontModifier(
                font: font,
                size: size,
                lineHeight: lineHeight,
                color: color
            )
        )
    }
}

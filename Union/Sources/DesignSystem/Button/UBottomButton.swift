//
//  UBottomButton.swift
//  Union
//
//  Created by 박서연 on 1/23/25.
//

import SwiftUI

/// 앱 내부에서 공통적으로 사용되는 버튼입니다.
struct UBottomButton: View {
    /// 버튼 제목
    let title: String
    
    /// 버튼 스타일과 관련된 설정
    let type: ButtonConfiguartion
    
    /// 버튼이 활성화되었는지 여부, 이미지가 있는 경우에만 사용
    let tapped: Bool
    
    /// 버튼에 사용할 이미지 (옵션)
    let image: ImageResource?
    
    /// 버튼이 눌렸을 때 실행할 동작 (옵션)
    var action: (() -> Void)?
    
    init(
        title: String,
        type: ButtonConfiguartion,
        tapped: Bool = false,
        image: ImageResource? = nil,
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.type = type
        self.tapped = tapped
        self.image = image
        self.action = action
    }
    
    var body: some View {
        Capsule()
            .stroke(type.borderColor, lineWidth: type.borderWidth)
            .background(Capsule().fill(type.background))
            .frame(height: type.height)
            .overlay {
                if let image = image, tapped {
                    HStack(spacing: 4) {
                        Image(image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                        titleView()
                    }
                } else {
                    titleView()
                }
            }
            .onTapGesture {
                action?()
            }
    }
    
    @ViewBuilder
    func titleView() -> some View {
        Text(title)
            .utypograph(
                font: type.weight,
                size: type.titleSize,
                lineHeight: type.titleLineHeight,
                color: type.textColor
            )
            .padding(.vertical, type.verticalPadding)
    }
}

extension UBottomButton {
    /// 버튼 스타일과 관련된 설정 정의한 열거형
    enum ButtonConfiguartion {
        case large(Bool)
        case medium(Bool)
        
        // 상하 여백
        var verticalPadding: CGFloat {
            switch self {
            case .large:
                return 12
            case .medium:
                return 8
            }
        }
        
        // 버튼 높이
        var height: CGFloat {
            switch self {
            case .large:
                return 48
            case .medium:
                return 32
            }
        }
        
        // 텍스트 크기
        var titleSize: CGFloat {
            switch self {
            case .large:
                return 16
            case .medium:
                return 16
            }
        }
        
        // 텍스트 라인 높이
        var titleLineHeight: CGFloat {
            switch self {
            case .large:
                return 24
            case .medium:
                return 16
            }
        }
        
        // 텍스트의 폰트 굵기
        var weight: UFont {
            switch self {
            case .large, .medium:
                return .bold
            }
        }
        
        // 텍스트 색상
        var textColor: Color {
            switch self {
            case .large(let tapped), .medium(let tapped):
                return tapped ? Color.blue4232D5 : Color.white
            }
        }
        
        // 배경 색상
        var background: Color {
            switch self {
            case .large(let bool), .medium(let bool):
                bool ? Color.white : Color.blue4232D5
            }
        }
        
        // 테두리 색상
        var borderColor: Color {
            switch self {
            case .large(let tapped):
                return tapped ? Color.blue4232D5 : Color.clear
            case .medium:
                return Color.clear
            }
        }
        
        // 테두리 두께
        var borderWidth: CGFloat {
            switch self {
            case .large, .medium:
                return 1
            }
        }
    }
    
    /// 버튼 동작을 설정하는 메서드
    /// - Parameter action: 실행할 동작
    /// - Returns: 업데이트된 버튼 인스턴스
    func tap(action: @escaping (() -> Void)) -> Self {
        var copy: Self = self // 기존 버튼을 복사
        copy.action = action // 동작 설정
        return copy // 업데이트된 버튼 반환
    }
}

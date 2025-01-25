//
//  UPopupModifier.swift
//  Union
//
//  Created by 박서연 on 1/23/25.
//

import SwiftUI

/// 팝업 컨테이너 (공통 레이아웃)
struct UPopupModifier<InnerContent: View>: ViewModifier {
    /// 팝업의 기본 패딩
    private let defaultInnerPadding: CGFloat = 40
    /// 팝업 배경의 기본 불투명도
    /// 0.0 = 완전 투명, 1.0 = 완전 불투명
    private let defaultBackgroundOpacity: Double = 0.6
    /// 팝업에 표시될 내부 콘텐츠 클로저
    private let innerContent: () -> InnerContent
    /// 팝업 표시 여부
    @Binding private var isPresented: Bool
    
    // UPopupModifier 초기화 메서드
    /// - Parameters:
    ///   - isPresented: 팝업 표시 여부를 제어하는 Binding
    ///   - newContent: 팝업에 표시될 내부 콘텐츠 클로저
    public init(
        isPresented: Binding<Bool>,
        newContent: @escaping () -> InnerContent
    ) {
        self._isPresented = isPresented
        self.innerContent = newContent
    }
    
    func body(content: Content) -> some View {
        ZStack {
            // 기존뷰
            content
                .zIndex(0)
            
            if isPresented {
                // 반투명 배경
                Color.black.opacity(defaultBackgroundOpacity)
                    .ignoresSafeArea()
                    .zIndex(1)
                    .onTapGesture {
                        isPresented = false
                    }
                
                // 팝업 뷰
                self.innerContent()
                    .zIndex(2)
                    .padding(.horizontal, defaultInnerPadding)
                    
            }
        }
        .animation(.easeInOut, value: isPresented)
    }
}

extension View {
    /// `UPopUp.Alert` 팝업 전용 View Modifier
    /// - Parameters:
    ///   - isPresented: 팝업 표시 여부를 제어하는 Binding
    ///   - content: 팝업 알림 내용을 구성하는 클로저
    /// - Returns: 팝업이 추가된 View
    func uPopUp(isPresented: Binding<Bool>, content: @escaping () -> UPopupView) -> some View {
        self.modifier(UPopupModifier(isPresented: isPresented, newContent: content))
    }
}

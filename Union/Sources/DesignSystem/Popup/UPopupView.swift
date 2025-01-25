//
//  UPopup.swift
//  Union
//
//  Created by 박서연 on 1/23/25.
//

import SwiftUI

/// UPopUpAlertView에 표시하는 정보입니다.
/// 팝업의 제목, 메시지, 버튼 정보를 포함.
public struct UPopupAlertState: Equatable {
    /// 팝업 제목
    public var title: String
    /// 팝업 메시지 (옵션)
    public var message: String
    /// 버튼 제목
    public var button: String
    
    
    /// TPopupAlertState 초기화 메서드
    /// - Parameters:
    ///   - title: 팝업의 제목
    ///   - message: 팝업의 메시지 (선택 사항, 기본값: `nil`)
    ///   - buttons: 팝업에 표시할 버튼
    public init(
        title: String,
        message: String,
        button: String
    ) {
        self.title = title
        self.message = message
        self.button = button
    }
}

/// 앱 내부에서 사용되는 팝업입니다.
struct UPopupView: View {
    /// 팝업 제목
    public var title: String
    /// 팝업 메시지 (옵션)
    public var message: String
    /// 버튼 제목
    public var button: String
    /// 버튼의 액션
    public var action: (() -> Void)?
    
    
    /// TPopupAlertState 초기화 메서드
    /// - Parameters:
    ///   - title: 팝업의 제목
    ///   - message: 팝업의 메시지 (선택 사항, 기본값: `nil`)
    ///   - buttons: 팝업에 표시할 버튼
    public init(
        title: String,
        message: String,
        button: String,
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.message = message
        self.button = button
        self.action = action
    }
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 4) {
                Text(title)
                    .utypograph(font: .meduim, size: 16, lineHeight: 24)
                
                Text(message)
                    .utypograph(font: .regular, size: 14, lineHeight: 20)
            }
            .frame(maxWidth: .infinity)
            .padding(.init(top: 18,leading: 16,bottom: 16,trailing: 18))
            
            Rectangle()
                .fill(Color.grayAEAEB2)
                .frame(height: 0.5)
            
            Text(button)
                .utypograph(font: .meduim, size: 16, lineHeight: 24, color: .blue4232D5)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .onTapGesture {
                    action?()
                }
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .frame(height: 128)
        // ipad를 제외하고 iphone을 기준으로 오토레이아웃을 위하여 height만 지정(width: 외부에서 Padding 사용)
    }
}

extension UPopupView {
    /// 버튼 동작을 설정하는 메서드
    /// - Parameter action: 실행할 동작
    /// - Returns: 업데이트된 button
    func tap(action: @escaping (() -> Void)) -> Self {
        var copy: Self = self
        copy.action = action
        return copy
    }
}


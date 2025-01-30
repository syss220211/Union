//
//  UNavigation.swift
//  Union
//
//  Created by 박서연 on 1/23/25.
//

import SwiftUI

/// 네비게이션 바의 유형을 정의하는 열거형
enum UNavigationCase {
    /// 오른쪽 이미지 버튼, 센터 타이틀
    case RButtontitle(title: String, leftImage: ImageResource)
    /// 왼쪽 이미지 버튼, 오른쪽 이미지 버튼, 센터 타이틀
    case LRBUttonTitle(title: String, leftImage: ImageResource, rightImage: ImageResource)
}

/// 앱 내에서 사용되는 네비게이션 컴포넌트 입니다.
struct UNavigation: View {
    /// 네비게이션 타입을 정의하는 열거형 (`UNavigationCase`)
    let type: UNavigationCase
    /// 왼쪽 버튼 동작 (옵셔널)
    public var leftAction: (() -> Void)?
    /// 오른쪽 버튼 동작 (옵셔널)
    public var rightAction: (() -> Void)?
    
    public init(
        type: UNavigationCase,
        leftAction: (() -> Void)? = nil,
        rightAction: (() -> Void)? = nil
    ) {
        self.type = type
        self.leftAction = leftAction
        self.rightAction = rightAction
    }
    
    var body: some View {
        HStack {
            // 왼쪽 뷰
            leftView
            Spacer()
            // 중앙 타이틀
            titleView
            Spacer()
            // 오른쪽 뷰
            rightView
        }
        .padding(16)
        .background(Color.white)
        .frame(height: 56)
    }
    
    @ViewBuilder
    private var leftView: some View {
        switch type {
        case .RButtontitle:
            EmptyView()
        case .LRBUttonTitle(_, let leftImage, _):
            Image(leftImage)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .onTapGesture {
                    leftAction?()
                }
        }
    }
    
    @ViewBuilder
    private var rightView: some View {
        switch type {
        case .RButtontitle(_, let leftImage):
            Image(leftImage)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .onTapGesture {
                    rightAction?()
                }
        case .LRBUttonTitle(_, _,let rightImage):
            Image(rightImage)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .onTapGesture {
                    rightAction?()
                }
        }
    }
    
    @ViewBuilder
    private var titleView: some View {
        switch type {
        case .RButtontitle(let title, _):
            Text(title)
                .utypograph(font: .meduim, size: 18, lineHeight: 26)
        case .LRBUttonTitle(let title, _, _):
            Text(title)
                .utypograph(font: .meduim, size: 18, lineHeight: 26)
        }
    }
}

extension UNavigation {
    /// 왼쪽 버튼 동작을 설정하는 메서드
    /// - Parameter leftAction: 실행할 동작
    /// - Returns: 업데이트된 TNavigation
    func leftTap(leftAction: @escaping (() -> Void)) -> Self {
        var copy: Self = self
        copy.leftAction = leftAction
        return copy
    }
    
    /// 오른쪽 버튼 동작을 설정하는 메서드
    /// - Parameter rightAction: 실행할 동작
    /// - Returns: 업데이트된 TNavigation
    func rightTap(rightAction: @escaping (() -> Void)) -> Self {
        var copy: Self = self
        copy.rightAction = rightAction
        return copy
    }
}


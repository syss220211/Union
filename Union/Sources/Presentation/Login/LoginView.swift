//
//  LoginView.swift
//  Union
//
//  Created by 박서연 on 1/27/25.
//

import SwiftUI

struct LoginView: View {
    @State var text: String = ""
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.gray060203

            VStack(spacing: 0) {
                UNavigation(type: .RButtontitle(title: "2024 WMU", leftImage: .icCloseLine))

                VStack(spacing: 0) {
                    Image(.crownBackground)
                        .resizable()
                        .scaledToFit()

                    Spacer().frame(height: 32)
                    VStack(spacing: 24) {
                        UTextField(text: $text)
                        
                        UBottomButton(title: "Log in", type: .large(false))
                            .tap {
                                // 네비게이션
                            }
                    }
                    .padding(.horizontal, 16)
                    Spacer()
                }
                
                Spacer()
            }

            Image(.earthBackground)
                .resizable()
                .scaledToFit()
        }
        .ignoresSafeArea(edges: .bottom) // 전체 뷰에서 하단 안전 영역을 무시
    }
}

#Preview {
    LoginView()
}

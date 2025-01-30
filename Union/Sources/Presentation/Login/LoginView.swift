//
//  LoginView.swift
//  Union
//
//  Created by 박서연 on 1/27/25.
//

import SwiftUI


struct LoginView: View {
    @StateObject var viewModel = LoginViewModel()
    @EnvironmentObject var router: Router
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.gray060203
                .onTapGesture { hideKeyboard() }
            
            VStack(spacing: 0) {
                UNavigation(type: .RButtontitle(title: "2024 WMU", leftImage: .icCloseLine))

                VStack(spacing: 0) {
                    Image(.crownBackground)
                        .resizable()
                        .scaledToFit()

                    Spacer().frame(height: 32)
                    VStack(spacing: 24) {
                        UTextField(text: $viewModel.userID)
                        
                        UBottomButton(title: "Log in", type: .large(false))
                            .tap {
                                if viewModel.userID.isEmpty {
                                    print("login Toast: \(viewModel.buttonToast)")
                                    viewModel.buttonToast = true
                                } else {
                                    router.userID = viewModel.userID
                                    router.navigateTo(.votingView(userID: viewModel.userID))
                                }
                            }
                    }
                    .padding(.horizontal, 16)
                    .keyboardAware()
                    Spacer()
                }
                
                Spacer()
            }
            
            Image(.earthBackground)
                .resizable()
                .scaledToFit()
        }
        .ignoresSafeArea(edges: .bottom)
        .UToast($viewModel.buttonToast, .fail, "아이디를 입력해주세요")
    }
}

#Preview {
    LoginView()
        .environmentObject(Router())
}


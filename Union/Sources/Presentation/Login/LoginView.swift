//
//  LoginView.swift
//  Union
//
//  Created by 박서연 on 1/27/25.
//

import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var userID: String = ""
    @Published var buttonToast: Bool = false
}

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
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct KeyboardAwareModifier: ViewModifier {
    @State private var keyboardHeight: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .padding(.bottom, keyboardHeight)
            .onAppear {
                NotificationCenter.default.addObserver(
                    forName: UIResponder.keyboardWillShowNotification,
                    object: nil,
                    queue: .main
                ) { notification in
                    if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                        keyboardHeight = keyboardFrame.height - 40 
                    }
                }

                NotificationCenter.default.addObserver(
                    forName: UIResponder.keyboardWillHideNotification,
                    object: nil,
                    queue: .main
                ) { _ in
                    keyboardHeight = 0
                }
            }
            .onDisappear {
                NotificationCenter.default.removeObserver(self)
            }
    }
}

extension View {
    func keyboardAware() -> some View {
        self.modifier(KeyboardAwareModifier())
    }
}

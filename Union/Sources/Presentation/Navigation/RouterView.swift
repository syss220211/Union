//
//  RouterView.swift
//  Union
//
//  Created by 박서연 on 1/29/25.
//

import SwiftUI

/// `Router`를 활용한 네비게이션 관리 뷰
struct RouterView<Content: View>: View {
    @StateObject private var router = Router.shared
    private let content: Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }

    var body: some View {
        NavigationView {
            VStack {
                content

                // NavigationLink들을 동적으로 생성하여 화면 전환 관리
                ForEach(router.navigationStack.indices, id: \.self) { index in
                    buildNavigationLink(for: router.navigationStack[index], at: index)
                }
            }
        }
        .environmentObject(router)  // Router를 모든 하위 뷰에서 사용할 수 있도록 전달
    }

    /// 특정 `Route`에 대한 NavigationLink 생성
    @ViewBuilder
    private func buildNavigationLink(for route: Route, at index: Int) -> some View {
        switch route {
        case .loginView:
            NavigationLink(
                destination: LoginView(),
                isActive: Binding(
                    get: { index == router.navigationStack.count - 1 },
                    set: { newValue in
                        if !newValue { router.navigateBack() }
                    }
                )
            ) { EmptyView() }
        case .votingView(let userID):
            NavigationLink(
                destination: VotingView(viewModel: VotingViewModel(userID: userID)),
                isActive: Binding(
                    get: { index == router.navigationStack.count - 1 },
                    set: { newValue in
                        if !newValue { router.navigateBack() }
                    }
                )
            ) { EmptyView() }
        }
    }
}

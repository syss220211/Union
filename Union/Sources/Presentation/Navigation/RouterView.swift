//
//  RouterView.swift
//  Union
//
//  Created by 박서연 on 1/29/25.
//

import SwiftUI

import SwiftUI

/// 앱의 화면 경로(Route)를 정의하는 Enum
enum Route: Hashable, Identifiable {
    case loginView
    case votingView(userID: String)

    var id: Self { self }
}

/// 화면 이동을 관리하는 Router (ObservableObject)
final class Router: ObservableObject {
    @Published var navigationStack: [Route] = []
    @Published var userID: String = ""
    static let shared = Router()  // 싱글턴 패턴으로 전역에서 접근 가능

    /// 특정 화면으로 이동
    func navigateTo(_ page: Route) {
        navigationStack.append(page)
    }

    /// 뒤로 가기
    func navigateBack() {
        guard !navigationStack.isEmpty else { return }
        navigationStack.removeLast()
    }

    /// 루트로 이동 (초기 화면으로 이동)
    func popToRoot() {
        navigationStack.removeAll()
    }
}

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
                content  // 메인 콘텐츠

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


//struct RouterView<Content: View>: View {
//    @StateObject var router: Router = Router()
//    private let content: Content
//    
//    init(@ViewBuilder content: @escaping () -> Content) {
//        self.content = content()
//    }
//    
//    var body: some View {
//        NavigationView {
//            VStack {
//                content
//                
//                // 각 화면별 NavigationLink를 개별적으로 관리
//                NavigationLink(
//                    destination: VotingView(viewModel: VotingViewModel(userID: router.userID ?? "")),
//                    isActive: Binding(
//                        get: { router.activeRoute == .votingView(userID: router.userID ?? "") },
//                        set: { newValue in
//                            if !newValue { router.activeRoute = nil }
//                        }
//                    )
//                ) { EmptyView() }
//
//                NavigationLink(
//                    destination: LoginView(),
//                    isActive: Binding(
//                        get: { router.activeRoute == .loginView },
//                        set: { newValue in
//                            if !newValue { router.activeRoute = nil }
//                        }
//                    )
//                ) { EmptyView() }
//            }
//            .environmentObject(router)
//        }
//    }
//}
//
//final class Router: ObservableObject {
//    enum Route: Hashable, Identifiable {
//        case loginView
//        case votingView(userID: String)
//        case candidateDetailView
//        
//        var id: Self { self }
//    }
//    
//    @Published var activeRoute: Route? = nil
//    var userID: String? = nil // 유저 ID를 저장
//
//    func navigateTo(_ page: Route) {
//        switch page {
//        case .votingView(let userID):
//            self.userID = userID
//        default:
//            break
//        }
//        activeRoute = page
//    }
//    
//    func navigateBack() {
//        activeRoute = nil
//    }
//    
//    func popToRoot() {
//        activeRoute = nil
//    }
//}

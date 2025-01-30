//
//  RouterView.swift
//  Union
//
//  Created by 박서연 on 1/29/25.
//

import SwiftUI

import SwiftUI

struct RouterView<Content: View>: View {
    @StateObject var router: Router = Router()
    private let content: Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        NavigationView {
            VStack {
                content
                
                // 각 화면별 NavigationLink를 개별적으로 관리
                NavigationLink(
                    destination: VotingView(viewModel: VotingViewModel(userID: router.userID ?? "")),
                    isActive: Binding(
                        get: { router.activeRoute == .votingView(userID: router.userID ?? "") },
                        set: { newValue in
                            if !newValue { router.activeRoute = nil }
                        }
                    )
                ) { EmptyView() }

                NavigationLink(
                    destination: LoginView(),
                    isActive: Binding(
                        get: { router.activeRoute == .loginView },
                        set: { newValue in
                            if !newValue { router.activeRoute = nil }
                        }
                    )
                ) { EmptyView() }
                
//                NavigationLink(
//                    destination: CandidateDetailView(),
//                    isActive: Binding(
//                        get: { router.activeRoute == .candidateDetailView },
//                        set: { newValue in
//                            if !newValue { router.activeRoute = nil }
//                        }
//                    )
//                ) { EmptyView() }
            }
            .environmentObject(router)
        }
    }
}

final class Router: ObservableObject {
    enum Route: Hashable, Identifiable {
        case loginView
        case votingView(userID: String)
        case candidateDetailView
        
        var id: Self { self }
    }
    
    @Published var activeRoute: Route? = nil
    var userID: String? = nil // 유저 ID를 저장

    func navigateTo(_ page: Route) {
        switch page {
        case .votingView(let userID):
            self.userID = userID
        default:
            break
        }
        activeRoute = page
    }
    
    func navigateBack() {
        activeRoute = nil
    }
    
    func popToRoot() {
        activeRoute = nil
    }
}

//
//  Router.swift
//  Union
//
//  Created by 박서연 on 1/29/25.
//

import SwiftUI

//final class Router: ObservableObject {
//    enum Route: Hashable, Identifiable {
//        var id: Self { self }
//        
//        case loginView
//        case votingView(userID: String)
//        case candidateDetailView
//    }
//    
//    @Published var activeRoute: Route?
//    @Published var isActive: Bool = false
//    
//    @ViewBuilder func view(for route: Route) -> some View {
//        switch route {
//        case .loginView:
//            LoginView()
//        case .votingView(let userID):
//            VotingView(userID: userID)
//        case .candidateDetailView:
//            CandidateDetailView()
//        }
//    }
//    
//    func navigateTo(_ page: Route) {
//        activeRoute = page
//        isActive = true
//    }
//    
//    func navigateBack() {
//        isActive = false
//        activeRoute = nil
//    }
//    
//    func popToRoot() {
//        isActive = false
//        activeRoute = nil
//    }
//    
//    func replaceNavigationStack(_ page: Route) {
//        activeRoute = page
//        isActive = true
//    }
//}
//

//
//  Router.swift
//  Union
//
//  Created by 박서연 on 1/29/25.
//

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

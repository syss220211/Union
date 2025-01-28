//
//  RouterView.swift
//  Union
//
//  Created by 박서연 on 1/29/25.
//

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
                
                NavigationLink(
                    isActive: $router.isActive,
                    destination: {
                        if let route = router.activeRoute {
                            router.view(for: route)
                                .environmentObject(router) // 새로운 뷰에도 router 전달
                        }
                    },
                    label: { EmptyView() }
                )
            }
            .environmentObject(router) // content에 router 전달
        }
    }
}

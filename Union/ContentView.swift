//
//  ContentView.swift
//  Union
//
//  Created by 박서연 on 1/25/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var router = Router()
    
    var body: some View {
        RouterView {
            LoginView()
        }
        .environmentObject(router)
    }
}

#Preview {
    ContentView()
}

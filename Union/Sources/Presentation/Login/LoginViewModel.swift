//
//  LoginViewModel.swift
//  Union
//
//  Created by 박서연 on 1/30/25.
//

import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var userID: String = ""
    @Published var buttonToast: Bool = false
}


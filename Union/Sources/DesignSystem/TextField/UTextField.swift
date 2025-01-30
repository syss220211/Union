//
//  UTextField.swift
//  Union
//
//  Created by 박서연 on 1/27/25.
//

import SwiftUI

struct UTextField: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            TextField(text: $text) {
                HStack(spacing: 4) {
                    Text("Enter your ID")
                        .utypograph(font: .regular, size: 13, lineHeight: 18, color: .grayAEAEB2)
                }
            }
            .foregroundStyle(Color.white)
            .onChange(of: text) { newValue in
                // 30글자 이상 입력되지 않도록 제한
                if newValue.count > 30 {
                    text = String(newValue.prefix(30))
                }
            }
            Text("\(text.count)/30")
                .utypograph(font: .meduim, size: 14, lineHeight: 20, color: .gray3C3C43.opacity(0.6))
        }
//        .padding(.init(top: 12,leading: 16,bottom: 12,trailing: 16))
        .padding(.horizontal, 12)
        .frame(height: 48)
        .background(Color.white.opacity(0.12))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.grayDBDBDB.opacity(0.8), lineWidth: 0.5)
        }    }
}

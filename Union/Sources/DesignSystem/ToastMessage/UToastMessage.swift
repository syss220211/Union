//
//  UToastMessage.swift
//  Union
//
//  Created by 박서연 on 1/28/25.
//

import SwiftUI

enum ToastMessageType {
    case success
    case fail
    
    var background: Color {
        switch self {
        case .success:
            return .green
        case .fail:
            return .red
        }
    }
    
    var textColor: Color {
        switch self {
        case .success, .fail:
            return .gray060203
        }
    }
    
    var image: Image {
        switch self {
        case .success:
            return Image(systemName: "checkmark")
        case .fail:
            return Image(.icCloseLine)
        }
    }
}

struct UToastMessageView: View {
    let desc: String
    let type: ToastMessageType
    
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(type.background)
            .frame(height: 40)
            .overlay {
                HStack(spacing: 10) {
                    type.image
                        .resizable()
                        .frame(width: 10, height: 10)
                        .foregroundStyle(type.textColor)
                    
                    Text(desc)
                        .utypograph(font: .meduim, size: 15, lineHeight: 15, color: type.textColor)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal, 20)
            }
    }
}

//struct ToastViewModifer: ViewModifier {
//    @Binding var isShowing: Bool
//    let desc: String
//    let type: ToastMessageType
//    
//    public func body(content: Content) -> some View {
//        ZStack(alignment: .bottom) {
//            content
//            
//            if isShowing {
//                UToastMessageView(desc: desc, type: type)
//                    .padding(.horizontal, 24)
//                    .onAppear {
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//                            withAnimation {
//                                isShowing = false
//                            }
//                        }
//                    }
//            }
//        }
//    }
//}
struct ToastViewModifer: ViewModifier {
    @Binding var isShowing: Bool
    let desc: String
    let type: ToastMessageType
    
    func body(content: Content) -> some View {
        ZStack {
            content
                .edgesIgnoringSafeArea(.bottom) // 뷰의 하단까지 확장
            
            if isShowing {
                VStack {
                    Spacer()
                    UToastMessageView(desc: desc, type: type)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 30) // 화면 하단에서 약간 위에 위치
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                withAnimation {
                                    isShowing = false
                                }
                            }
                        }
                }
                .transition(.move(edge: .bottom)) // 화면 하단에서 나타나는 효과
                .animation(.easeInOut(duration: 0.3), value: isShowing) // 부드럽게 나타나고 사라지도록 애니메이션
            }
        }
    }
}
extension View {
    func UToast(_ isShowing: Binding<Bool>,
                _ type: ToastMessageType,
                _ desc: String) -> some View
    {
        self.modifier(ToastViewModifer(isShowing: isShowing, desc: desc, type: type))
    }
}

struct MTest: View {
    @State private var isToastShowing: Bool = false

    var body: some View {
        VStack {
            Button("Show Toast") {
                isToastShowing = true
            }
            
            Text("Hello World")
                .onTapGesture {
                    print("isToastShowing \(isToastShowing)")
                }
        }
        .UToast($isToastShowing, .success, "This is a success message!")
    }
}

#Preview {
    MTest()
}

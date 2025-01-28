//
//  CandidateDetailView.swift
//  Union
//
//  Created by 박서연 on 1/28/25.
//

import SwiftUI
import Combine
import Kingfisher

struct CandidateDetailView: View {
    @StateObject var viewModel = CandidateDetailViewModel()
    @StateObject var mainVM = VotingViewModel()
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 0) {
                    UNavigation(
                        type: .LRBUttonTitle(
                            title: "2024 WMU",
                            leftImage: .icArrowLeft,
                            rightImage: .icCloseLine
                        )
                    )
                    
                    candidateImage()
                    
                    Spacer().frame(height: 26)
                    
                    VStack(spacing: 26) {
                        candidateHeader()
                        candidateInfo()
                        bottom()
                    }
                    .padding(.horizontal, 20)
                }
                .background(Color.gray060203)
            }
            .UPopUp(isPresented: $mainVM.popupSuccessFlag, content: {
                UPopupView(
                    title: "Voting Completed",
                    message: "Tank you for voting",
                    button: "Confirm") {
                        mainVM.popupSuccessFlag = false
                    }
            })
            .UToast($mainVM.toastMessageFailFlag, .fail, mainVM.errorMessage)
        }
        .onAppear {
            viewModel.action(.startTimer)
            viewModel.action(.getCandidateDetailInfo)
        }
        .onDisappear {
            viewModel.action(.stopTimer)
        }
        .navigationBarBackButtonHidden()
        .ignoresSafeArea(edges: .bottom)
        
    }
}

extension CandidateDetailView {
    @ViewBuilder
    private func bottom() -> some View {
        Text("COPYRIGHT © WUPSC ALL RIGHT RESERVED.")
            .utypograph(font: .light, size: 10, lineHeight: 16, color: .white)
            .padding(.vertical, 21.5)
        
        
        UBottomButton(
            title: (viewModel.cadidateDetail?.voted ?? false) ? "Voted" : "Vote",
            type: .large(viewModel.cadidateDetail?.voted ?? false),
            tapped: viewModel.cadidateDetail?.voted ?? false,
            image: .icnVoted
        )
        .tap {
            mainVM.popupSuccessFlag = true
//            guard let candidate = viewModel.cadidateDetail else { return }
//            mainVM.action(.postVote(candidateID: candidate.id))
        }
        .padding(.init(top: 12, leading: 16, bottom: 24, trailing: 16))
    }
    
    @ViewBuilder
    private func candidateInfo() -> some View {
        VStack(alignment: .leading) {
            ForEach(0..<(viewModel.cadidateDetail?.details.count ?? 0), id: \.self) { index in
                if let detail = viewModel.cadidateDetail?.details {
                    VStack(spacing: 0) {
                        ItemView(title: detail[index].title, desc: detail[index].content)
                            .padding(.vertical, 12)
                        Rectangle()
                            .fill(Color.gray252525)
                            .frame(height: 1)
                            .opacity(index == detail.count - 1 ? 0 : 1)
                    }
                } else {
                    EmptyView()
                }
            }
            .padding(.init(top: 6, leading: 14, bottom: 6, trailing: 14))
        }
        .background(Color.white.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }
    
    @ViewBuilder
    private func candidateHeader() -> some View {
        VStack(spacing: 6) {
            Text(viewModel.cadidateDetail?.name ?? "")
                .utypograph(font: .meduim, size: 22, lineHeight: 26, color: Color.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("Entry No.\(viewModel.cadidateDetail?.candidateNumber ?? 0)")
                .utypograph(font: .meduim, size: 14, lineHeight: 20, color: .blue6F76FF)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    @ViewBuilder
    private func ItemView(title: String, desc: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            // TODO: - font
            Text(title)
                .utypograph(font: .bold, size: 14, lineHeight: 16, color: .gray7C7C7C)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(desc)
                .utypograph(font: .bold, size: 16, lineHeight: 19, color: .grayF6F6F6)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    @ViewBuilder
    private func candidateImage() -> some View {
        TabView(selection: $viewModel.currentProfileIndex) {
            ForEach(0..<viewModel.imageList.count, id: \.self) { index in
                KFImage(URL(string: viewModel.imageList[index].profileUrl))
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
                    .tag(index) // index를 사용하여 currentProfileIndex와 동기화
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
        .overlay(alignment: .bottom) {
            HStack(spacing: 8) {
                ForEach(0..<viewModel.imageList.count, id: \.self) { dotIndex in
                    Circle()
                        .fill(viewModel.currentProfileIndex == dotIndex ? Color.blue4232D5 : Color.gray.opacity(0.8))
                        .frame(width: 8, height: 8)
                }
            }
            .padding(.bottom, 10)
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    let width = value.translation.width
                    withAnimation {
                        if width < -50 { // 오른쪽으로 넘어감, 인덱스 증가
                            if viewModel.currentProfileIndex == viewModel.imageList.count-1 {
                                viewModel.currentProfileIndex = 0
                            } else {
                                viewModel.currentProfileIndex = min(viewModel.currentProfileIndex + 1, Int(viewModel.imageList.count-1))
                            }
                        } else {
                            if viewModel.currentProfileIndex == 0 {
                                viewModel.currentProfileIndex = viewModel.imageList.count - 1
                            } else {
                                viewModel.currentProfileIndex = max(viewModel.currentProfileIndex - 1, 0)
                            }
                        }
                        viewModel.action(.startTimer)
                    }
                }
        )
        .onReceive(viewModel.timer) { _ in
            withAnimation {
                if viewModel.currentProfileIndex == viewModel.imageList.count - 1 {
                    viewModel.currentProfileIndex = 0 /// 첫 번째로 돌아감
                } else {
                    viewModel.currentProfileIndex += 1 /// 다음 슬라이드로 이동
                }
            }
        }
    }
}

#Preview {
    CandidateDetailView()
}

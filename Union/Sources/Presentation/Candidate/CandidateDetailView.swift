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
    @ObservedObject var votingViewModel: VotingViewModel
    @StateObject var viewModel: CandidateDetailViewModel = CandidateDetailViewModel()
    @EnvironmentObject var router: Router
    @Environment(\.dismiss) var dismiss
    
    let userID: String
    let candidateID: Int
    
    init(
        votingViewModel: VotingViewModel,
        userID: String,
        candidateID: Int
    ) {
        self.votingViewModel = votingViewModel
        self.userID = userID
        self.candidateID = candidateID
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                if let candidate = viewModel.candidateDetail {
                    VStack(spacing: 0) {
                        header()
                        candidateImage()
                        Spacer().frame(height: 26)
                        
                        VStack(spacing: 26) {
                            candidateHeader(candidate: candidate)
                            candidateInfo(candidate: candidate)
                            bottom(candidate: candidate)
                        }
                        .padding(.horizontal, 20)
                    }
                    .background(Color.gray060203)
                } else {
                    ProgressView()
                        .tint(Color.blue4232D5)
                }
            }
            .UPopUp(isPresented: $votingViewModel.popupSuccessFlag, content: {
                UPopupView(
                    title: "Voting Completed",
                    message: "Tank you for voting",
                    button: "Confirm") {
                        votingViewModel.popupSuccessFlag = false
                    }
            })
            .UToast($votingViewModel.detailToastFail, .fail, votingViewModel.errorMessage)
        }
        .onAppear {
            viewModel.userID = userID
            viewModel.candidateID = candidateID
            viewModel.action(.getCandidateDetailInfo)
            viewModel.action(.startTimer)
        }
        .navigationBarBackButtonHidden()
        .ignoresSafeArea(edges: .bottom)
        .onDisappear {
            viewModel.action(.stopTimer)
        }
    }
}

extension CandidateDetailView {
    @ViewBuilder
    private func header() -> some View {
        UNavigation(
            type: .LRBUttonTitle(
                title: "2024 WMU",
                leftImage: .icArrowLeft,
                rightImage: .icCloseLine
            )
        )
        .leftTap {
            dismiss()
            
        }
        .rightTap {
            dismiss()
        }
    }
    
    @ViewBuilder
    private func bottom(candidate: CandidateDetailEntity) -> some View {
        Text("COPYRIGHT © WUPSC ALL RIGHT RESERVED.")
            .utypograph(font: .light, size: 10, lineHeight: 16, color: .white)
            .padding(.vertical, 21.5)
        
        UBottomButton(
            title:candidate.voted ? "Voted" : "Vote",
            type: .large(candidate.voted),
            tapped: candidate.voted,
            image: .icnVoted
        )
        .tap {
//            votingViewModel.action(.postVote(candidateID: candidate.id, type: .detail))
//            viewModel.action(.getCandidateDetailInfo)
            votingViewModel.action(.postVote(candidateID: candidate.id, type: .detail))
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                viewModel.action(.getCandidateDetailInfo)
            }
        }
        .padding(.init(top: 12, leading: 16, bottom: 24, trailing: 16))
    }
    
    @ViewBuilder
    private func candidateInfo(candidate: CandidateDetailEntity) -> some View {
        VStack(alignment: .leading) {
            ForEach(0..<candidate.profileInfoList.count, id: \.self) { index in
                VStack(spacing: 0) {
                    ItemView(title: candidate.details[index].title, desc: candidate.details[index].content)
                        .padding(.vertical, 12)
                    Rectangle()
                        .fill(Color.gray252525)
                        .frame(height: 1)
                        .opacity(index == candidate.details.count - 1 ? 0 : 1)
                }
            }
            .padding(.init(top: 6, leading: 14, bottom: 6, trailing: 14))
        }
        .background(Color.white.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }
    
    @ViewBuilder
    private func candidateHeader(candidate: CandidateDetailEntity) -> some View {
        VStack(spacing: 6) {
            Text(candidate.name)
                .utypograph(font: .meduim, size: 22, lineHeight: 26, color: Color.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("Entry No.\(candidate.candidateNumber)")
                .utypograph(font: .meduim, size: 14, lineHeight: 20, color: .blue6F76FF)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    @ViewBuilder
    private func ItemView(title: String, desc: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
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
                    .tag(index)
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


/*
 

 */

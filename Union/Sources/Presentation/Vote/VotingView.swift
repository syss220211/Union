//
//  VotingView.swift
//  Union
//
//  Created by 박서연 on 1/27/25.
//

import SwiftUI

struct VotingView: View {
    @ObservedObject var viewModel: VotingViewModel
    @StateObject private var timer = CountdownTimer()
    @EnvironmentObject var router: Router
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 0) {
                    Header()
                    imageSection()
                    
                    VStack(spacing: 30) {
                        WMUtitle()
                        WMUInfo()
                    }
                    .padding(.init(top: 50,leading: 16,bottom: 50,trailing: 16))
                    
                    CandidateListView(viewModel: viewModel)
                    
                    Spacer().frame(height: 25)
                    
                    Text("COPYRIGHT © WUPSC ALL RIGHT RESERVED.")
                        .utypograph(font: .light, size: 10, lineHeight: 16, color: Color.white)
                        .padding(.vertical, 22.5)
                }
                .background(Color.gray060203)
                .ignoresSafeArea(edges: .bottom)
            }
            .UToast($viewModel.votingToastFail, .fail, viewModel.errorMessage)
            .UToast($viewModel.votingToastSuccess, .success, viewModel.errorMessage)
            .ignoresSafeArea(edges: .bottom)
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            viewModel.action(.getCandidateList)
            viewModel.action(.votedCandidateList)
            viewModel.action(.getVotedCandidateListUser)
        }
    }
}

extension VotingView {
    @ViewBuilder
    func Header() -> some View {
        UNavigation(type: .RButtontitle(title: "2024 WMU", leftImage: .icCloseLine))
            .rightTap {
                router.navigateBack()
            }
    }
    
    @ViewBuilder
    func imageSection() -> some View {
        Image(.background)
            .resizable()
            .scaledToFit()
            .overlay(alignment: .bottom) {
                HStack {
                    ForEach(Time.allCases, id: \.self) { time in
                        VStack(spacing: 4) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.white.opacity(0.12))
                                .frame(width: 48,height: 48)
                                .overlay {
                                    Text("\(time.value(from: timer.timeComponents))")
                                        .utypograph(font: .meduim, size: 22, lineHeight: 12, color: .grayDBDBDB)
                                }
                            Text(time.rawValue)
                                .utypograph(font: .meduim, size: 10, lineHeight: 12, color: .grayDADADA)
                        }
                        .padding(.bottom, 55)
                    }
                }
            }
    }
    
    @ViewBuilder
    func WMUtitle() -> some View {
        VStack(spacing: 10) {
            Text("WORLD MISS UNIVERSITY")
                .utypograph(font: .meduim, size: 14, lineHeight: 13, color: .blue6F76FF)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("Mobile Voting\nInformation")
                .utypograph(font: .semibold, size: 28, lineHeight: 14.5, color: .white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 30)
            
            Text("2024 World Miss University brings\ntogether future global leaders who embody both\nbeauty and intellect.")
                .utypograph(font: .regular, size: 14, lineHeight: 22, color: .grayAEAEB2)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    @ViewBuilder
    func WMUInfo() -> some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(Color.white.opacity(0.05))
            .frame(height: 206)
            .overlay {
                VStack(spacing: 0) {
                    VStack(spacing: 0) {
                        HStack(spacing: 16) {
                            Text("Period")
                                .utypograph(font: .meduim, size: 13, lineHeight: 12, color: .grayF6F6F6)
                                .frame(width: 77, alignment: .leading)
                            
                            Text("10/17(Thu) 12PM - 10/31(Thu) 6PM")
                                .utypograph(font: .regular, size: 13, lineHeight: 12, color: .grayDBDBDB)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(.vertical, 14)
                        
                        Rectangle()
                            .fill(Color.white.opacity(0.04))
                            .frame(height: 1)
                    }
                    
                    HStack(alignment: .top, spacing: 16) {
                        Text("How to vote")
                            .frame(width: 77, alignment: .leading)
                            .utypograph(font: .meduim, size: 13, lineHeight: 12, color: .grayF6F6F6)
                            .alignmentGuide(.top) { dimension in
                                0 // 이 뷰의 top을 HStack의 top과 동일하게 설정
                            }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            BulletPointText("Up to three people can participate in early voting per day.")
                            BulletPointText("Three new voting tickets are issued every day at midnight (00:00), and you can vote anew every day during the early voting period")
                        }
                    }
                    .padding(.vertical, 14)
                }
                .padding(.horizontal, 14)
            }
    }
}

// 불릿 포인트 텍스트를 위한 보조 뷰
struct BulletPointText: View {
    let text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Text("•")
                .utypograph(font: .regular, size: 13, lineHeight: 12, color: .grayDBDBDB)
            Text(text)
                .utypograph(font: .regular, size: 13, lineHeight: 12, color: .grayDBDBDB)
                .foregroundColor(.white)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

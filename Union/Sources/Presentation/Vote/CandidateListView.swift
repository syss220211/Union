//
//  CandidateListView.swift
//  Union
//
//  Created by 박서연 on 1/27/25.
//

import SwiftUI
import Combine
import Kingfisher

struct CandidateListView: View {
    @ObservedObject var viewModel: VotingViewModel
    @EnvironmentObject var router: Router
    
    /// 뷰를 그리기 위한 객체
    private let columns: [GridItem] = Array(repeating: GridItem(.flexible()), count: 2)
    private let size = (UIScreen.main.bounds.width - 48) / 2
    
    var body: some View {
        VStack(alignment: .leading, spacing: 40) {
            Header()
            
            LazyVGrid(columns: columns, spacing: 40) {
                ForEach(viewModel.candidateList?.content ?? [], id: \.id) { data in
                    VStack(spacing: 18) {
                        NavigationLink {
                            CandidateDetailView(
                                votingViewModel: viewModel,
                                viewModel: CandidateDetailViewModel(
                                    userID: viewModel.userID,
                                    candidateID: data.id
                                )
                            )
                        } label: {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(.clear)
                                .frame(width: size, height: size)
                                .overlay {
                                    KFImage(URL(string: data.profileUrl))
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: size, height: size)
                                }
                        }
                        
                        VStack(spacing: 4){
                            Text(data.name)
                                .utypograph(font: .meduim, size: 16, lineHeight: 12, color: .grayF6F6F6)
                            
                            Text("\(data.voteCnt) voted")
                                .utypograph(font: .meduim, size: 14, lineHeight: 16, color: .blue6F76FF)
                                .padding(.bottom, 6)
                            
                            UBottomButton(
                                title: data.voted
                                ? "voted" : "vote",
                                type: .medium(data.voted)
                            )
                            .tap {
                                viewModel.action(.postVote(candidateID: data.id))
                                viewModel.votedButtonFlag.toggle()
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 19)
        }
        .onAppear {
            viewModel.action(.getCandidateList)
            viewModel.action(.votedCandidateList)
            viewModel.action(.getVotedCandidateListUser)
        }
        .onChange(of: viewModel.votedButtonFlag) { _ in
            viewModel.action(.getCandidateList)
            viewModel.action(.votedCandidateList)
            viewModel.action(.getVotedCandidateListUser)
        }
    }
    
    @ViewBuilder
    private func Header() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Rectangle()
                .fill(Color.blue6F76FF)
                .frame(width: 19.41, height: 3)
            
            Text("2024\nCadidate List")
                .utypograph(font: .semibold, size: 28, lineHeight: 14.5, color: Color.white)
            
            Text("※ You can vote for up to 3 candidates")
                .utypograph(font: .regular, size: 14, lineHeight: 18, color: Color.grayAEAEB2)
        }
        .padding(.horizontal, 16)
    }
}

//
//  CandidateDetailViewModel.swift
//  Union
//
//  Created by 박서연 on 1/28/25.
//

import Combine
import SwiftUI

class CandidateDetailViewModel: ObservableObject {
    @Published var timer = Timer.publish(every: 3.0, on: .main, in: .common).autoconnect()
    @Published var candidateDetail: CandidateDetailEntity?
    @Published var imageList: [ProfileInfoListEntity] = []
    @Published var currentProfileIndex = 0
    @Published var userID: String = ""
    @Published var candidateID: Int = 0
    
    private var cancellables = Set<AnyCancellable>()
    private let usecase = VoteUsecase(voteRepoProtocol: VoteRepository())
    
    enum Action {
        case getCandidateDetailInfo
        case startTimer
        case stopTimer
    }
    
    func action(_ action: Action) {
        switch action {
        case .getCandidateDetailInfo:
            let request: VoteType = .getCandidateDetailInfo(candidateID: candidateID, voterID: userID)
            usecase.getCandidateDetailInfo(request: request)
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print("error! \(error.localizedDescription)")
                    }
                } receiveValue: { [weak self] entity in
                    self?.candidateDetail = entity
                    self?.imageList = entity.profileInfoList
                }
                .store(in: &cancellables)
            
        case .startTimer:
            timer = Timer.publish(every: 3.0, on: .main, in: .common).autoconnect()
        case .stopTimer:
            timer.upstream.connect().cancel()
        }
    }
}

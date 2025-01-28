//
//  VotingViewModel.swift
//  Union
//
//  Created by 박서연 on 1/28/25.
//

import SwiftUI
import Combine

class VotingViewModel: ObservableObject {
    @Published var candidateList: CandidateListEntity?
    @Published var votedCandidateList: VotedCandidateListEntity?
    @Published var filteredVotedList: CandidateListEntity?
    @Published var postResult: VoteResultEntity?
    @Published var statusCode: Int?
    @Published var errorMessage: String = ""
    @Published var voteFlag: Bool = false
    @Published var popupSuccessFlag: Bool = false
    @Published var toastMessageFailFlag: Bool = false
    @Published var toastMessageSuccessFlag: Bool = false
    @Published var tappedCandidateID: Int?
    
    private let usecase = VoteUsecase(voteRepoProtocol: VoteRepository())
    private var cancellables = Set<AnyCancellable>()
    private let candidateListSubject = PassthroughSubject<CandidateListEntity, Never>()
    private let votedCandidateListSubject = PassthroughSubject<VotedCandidateListEntity, Never>()
    
    enum Action {
        /// 후보자 목록 가져오기
        case getCandidateList
        /// 유저가 투표한 후보자 목록 가져오기
        case votedCandidateList
        /// 후보자 리스트, 투표한 후보자 리스트 호출 후 해당 api 결과를 조합하여 유저가 투표한 후보자 리스트로 변환
        case getVotedCandidateListUser
        /// 투표하기
        case postVote(candidateID: Int)
        /// 후보자 선택
        case tappedCandidate(candidateID: Int)
    }
    
    func action(_ action: Action) {
            switch action {
            case .getCandidateList:
                let pageable = PageableRequestDTO(page: 1, size: 10, sort: [], searchKeyword: nil)
                let request = VoteType.getCandidateList(pageable: pageable)
                
                usecase.getCandidateList(request: request)
                    .receive(on: DispatchQueue.main)
                    .sink { completion in
                        switch completion {
                        case .finished:
                            break
                        case .failure(let error):
                            print("error: \(error.localizedDescription)")
                        }
                    } receiveValue: { [weak self] entity in
                        self?.candidateList = entity
                        self?.candidateListSubject.send(entity)
                    }
                    .store(in: &cancellables)
                
            case .votedCandidateList:
                let request: VoteType = .getVotedCandidateList(userID: "userA")
                usecase.getVotedCadidateList(request: request)
                    .receive(on: DispatchQueue.main)
                    .sink { completion in
                        switch completion {
                        case .finished:
                            break
                        case .failure(let error):
                            print("error: \(error.localizedDescription)")
                        }
                    } receiveValue: { [weak self] entity in
                        self?.votedCandidateList = entity
                        self?.votedCandidateListSubject.send(entity)
                    }
                    .store(in: &cancellables)
                
            case .getVotedCandidateListUser:
                Publishers.CombineLatest(candidateListSubject, votedCandidateListSubject)
                    .sink { [weak self] candidateList, votedList in
                        let updatedContent = candidateList.content.map { content in
                            var updatedContent = content
                            if votedList.candidates.contains(content.id) {
                                updatedContent.voted = true
                            }
                            return updatedContent
                        }
                        self?.candidateList = candidateList.updatingContent(with: updatedContent)
                    }
                    .store(in: &cancellables)
                
            case .postVote(let candidateID):
                let voteRequest: VoteRequestDTO = VoteRequestDTO(userId: "userABddD", id: candidateID)
                let request: VoteType = .postVote(candidate: voteRequest)
                usecase.postVote(request: request)
                    .receive(on: DispatchQueue.main)
                    .sink { completion in
                        switch completion {
                        case .finished:
                            self.errorMessage = "투표가 완료되었습니다."
                            self.toastMessageSuccessFlag = true
                            print("finised")
                            break
                        case .failure(let error):
                            switch error {
                            case .voteError(let statusCode, let data):
                                print("statusCode \(statusCode)")
                                self.errorMessage = StatusCode.message(forCode: statusCode) ?? "투표 중 에러가 발생하였습니다. 다시 시도해주세요."
                                self.statusCode = statusCode
                                self.postResult = data
                                self.toastMessageFailFlag = true
                                print("data \(data.errorCode)")
                            default:
                                self.errorMessage = "투표 중 에러가 발생하였습니다. 다시 시도해주세요."
                            }
                        }
                    } receiveValue: { [weak self] entity in
                        if entity.isEmpty {
                            self?.voteFlag = true
                            print("투표에 성공하였습니다.")
                        }
                        print("entity.... \(entity)")
                    }
                    .store(in: &cancellables)
                
            case .tappedCandidate(let candidateID):
                self.tappedCandidateID = candidateID
            }
        }
}

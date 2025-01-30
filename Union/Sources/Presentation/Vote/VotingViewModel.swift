//
//  VotingViewModel.swift
//  Union
//
//  Created by 박서연 on 1/28/25.
//

import SwiftUI
import Combine

enum VotingPlace {
    case main
    case detail
}

class VotingViewModel: ObservableObject {
    @Published var candidateList: CandidateListEntity?
    @Published var votedCandidateList: VotedCandidateListEntity?
    @Published var filteredVotedList: CandidateListEntity?
    @Published var postResult: VoteResultEntity?
    @Published var statusCode: Int?
    @Published var errorMessage: String = ""
    @Published var votingToastFail: Bool = false
    @Published var votingToastSuccess: Bool = false
    @Published var tappedCandidateID: Int?
    @Published var votedButtonFlag:Bool = false
    
    // MARK: - DetailFlag
    @Published var detailToastFail: Bool = false
    @Published var popupSuccessFlag: Bool = false
    
    // MARK: - Add Data
    @Published var page: Int = 1
    @Published var size: Int = 4
    @Published var hasMoreProducts: Bool = true
    @Published var isLoading = false
    
    public let userID: String
    private let usecase = VoteUsecase(voteRepoProtocol: VoteRepository())
    private var cancellables = Set<AnyCancellable>()
    private let candidateListSubject = PassthroughSubject<CandidateListEntity, Never>()
    private let votedCandidateListSubject = PassthroughSubject<VotedCandidateListEntity, Never>()
    
    init(userID: String) {
        self.userID = userID
    }
    
    enum Action {
        /// 후보자 목록 가져오기
        case getCandidateList
        /// 유저가 투표한 후보자 목록 가져오기
        case votedCandidateList
        /// 후보자 리스트, 투표한 후보자 리스트 호출 후 해당 api 결과를 조합하여 유저가 투표한 후보자 리스트로 변환
        case getVotedCandidateListUser
        /// 투표하기
        case postVote(candidateID: Int, type: VotingPlace)
    }
}

extension VotingViewModel {
    func action(_ action: Action) {
            switch action {
            case .getCandidateList:
                
                guard !isLoading && hasMoreProducts else { return }
                isLoading = true
                
                let pageable = PageableRequestDTO(page: page, size: size, sort: [], searchKeyword: nil)
                let request = VoteType.getCandidateList(pageable: pageable)
                
                usecase.getCandidateList(request: request)
                    .receive(on: DispatchQueue.main)
                    .sink { completion in
                        switch completion {
                        case .finished:
                            break
                        case .failure(let error):
                            print("error: \(error.localizedDescription)")
                            self.isLoading = false
                        }
                    } receiveValue: { [weak self] entity in
                        if entity.content.isEmpty {
                            self?.hasMoreProducts = false
                        } else if self?.page == 1 {
                            self?.candidateList = entity
                            self?.page += 1
                        } else {
                            self?.candidateList?.content.append(contentsOf: entity.content)
                            self?.page += 1
                        }

                        self?.isLoading = false
                    }
                    .store(in: &cancellables)
                
            case .votedCandidateList:
                let request: VoteType = .getVotedCandidateList(userID: userID)
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
                
            case .postVote(let candidateID, let type):
                let voteRequest: VoteRequestDTO = VoteRequestDTO(userId: userID, id: candidateID)
                let request: VoteType = .postVote(candidate: voteRequest)
                
                usecase.postVote(request: request)
                    .receive(on: DispatchQueue.main)
                    .sink { completion in
                        switch completion {
                        case .finished:
                            type == .main ? (self.votingToastSuccess = true) : (self.popupSuccessFlag = true)
                            self.errorMessage = "투표가 완료되었습니다."
                            break
                        case .failure(let error):
                            switch error {
                            case .voteError(let statusCode, let data):
                                self.postResult = data
                                self.errorMessage = StatusCode.message(forCode: statusCode) ?? "투표 중 에러가 발생하였습니다. 다시 시도해주세요."
                                type == .main ? (self.votingToastFail = true) : (self.detailToastFail = true)
                            default:
                                self.errorMessage = "투표 중 에러가 발생하였습니다. 다시 시도해주세요."
                            }
                        }
                    } receiveValue: { [weak self] entity in
                        self?.votedButtonFlag.toggle()
                    }
                    .store(in: &cancellables)
            }
        }
}

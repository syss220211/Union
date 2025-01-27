//
//  VoteUsecase.swift
//  Union
//
//  Created by 박서연 on 1/26/25.
//

import Foundation
import Combine

struct VoteUsecase {
    let voteRepoProtocol: VoteRepositoryProtocol
    
    func getCandidateDetailInfo(candidateID: Int, voterID: String) -> AnyPublisher<CandidateDetailEntity, NetworkError> {
        return voteRepoProtocol.getCandidateDetailInfo(candidateID: candidateID, voterID: voterID)
    }
    
    func getCandidateList(pageable: PageableRequest, searchKeyworkd: String) -> AnyPublisher<CandidateListEntity, NetworkError> {
        return voteRepoProtocol.getCandidateList(pageable: pageable, searchKeyworkd: searchKeyworkd)
    }
    
    func getVotedCadidateList(userId: String) -> AnyPublisher<VotedCandidateListEntity, NetworkError> {
        return voteRepoProtocol.getVotedCadidateList(userId: userId)
    }
    
    func postVote(candidate: VoteRequest) -> AnyPublisher<Data, NetworkError> {
        return voteRepoProtocol.postVote(candidate: candidate)
    }
}

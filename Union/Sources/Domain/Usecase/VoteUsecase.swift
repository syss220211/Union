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
    
//    func getCandidateDetailInfo() -> AnyPublisher<CandidateDetailDTO, NetworkError> {
//        return voteRepoProtocol.getCandidateDetailInfo()
//    }
//    
//    func getCandidateList() -> AnyPublisher<CandidateListDTO, NetworkError> {
//        return voteRepoProtocol.getCandidateList()
//    }
//    
    func getVotedCadidateList(userId: String) -> AnyPublisher<VotedCandidateListEntity, NetworkError> {
        return voteRepoProtocol.getVotedCadidateList(userId: userId)
    }
//    
//    func postVote(candidate: CandidateRequest) -> AnyPublisher<VoteResultDTO, NetworkError> {
//        return voteRepoProtocol.postVote(candidate: candidate)
//    }
}

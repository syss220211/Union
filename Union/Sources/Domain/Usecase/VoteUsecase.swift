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
    
    /// 후보자 상세정보 조회
    func getCandidateDetailInfo(request: VoteType) -> AnyPublisher<CandidateDetailEntity, NetworkError> {
        return voteRepoProtocol.getCandidateDetailInfo(request: request)
    }
    
    /// 후보자 목록 조회
    func getCandidateList(request: VoteType) -> AnyPublisher<CandidateListEntity, NetworkError> {
        return voteRepoProtocol.getCandidateList(request: request)
    }
    
    /// 유저가 투표한 후보자 목록 조회
    func getVotedCadidateList(request: VoteType) -> AnyPublisher<VotedCandidateListEntity, NetworkError> {
        return voteRepoProtocol.getVotedCadidateList(request: request)
    }
    
    /// 투표 실행
    func postVote(request: VoteType) -> AnyPublisher<Data, NetworkError> {
        return voteRepoProtocol.postVote(request: request)
    }
    
}

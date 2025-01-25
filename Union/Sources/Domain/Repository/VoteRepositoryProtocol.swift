//
//  VoteRepositoryProtocol.swift
//  Union
//
//  Created by 박서연 on 1/26/25.
//

import Foundation
import Combine

protocol VoteRepositoryProtocol {
//    func getCandidateDetailInfo() -> AnyPublisher<CandidateDetailDTO, NetworkError>
//    func getCandidateList() -> AnyPublisher<CandidateListDTO, NetworkError>
    /// 유저가 투표한 후보들의 id 리스트 조희 
    func getVotedCadidateList(userId: String) -> AnyPublisher<VotedCandidateListEntity, NetworkError>
//    func postVote(candidate: CandidateRequest) -> AnyPublisher<VoteResultDTO, NetworkError>
}

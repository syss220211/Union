//
//  VoteRepositoryProtocol.swift
//  Union
//
//  Created by 박서연 on 1/26/25.
//

import Foundation
import Combine

protocol VoteRepositoryProtocol {
    /// 후보자 상세정보 조회
    /// - Parameters:
    /// - path: 후보자 ID
    /// - query:  투표자 유저ID
    func getCandidateDetailInfo(candidateID: Int, voterID: String) -> AnyPublisher<CandidateDetailEntity, NetworkError>
    
    /// 후보자 리스트 조회
    /// - Parameters:
    ///     - query: 현재페이지(page), 한 페이지당 개수(size), 정렬조건(sort), 후보자 이름 검색 키워드(searchKeyword)
    func getCandidateList(pageable: PageableRequest, searchKeyworkd: String) -> AnyPublisher<CandidateListEntity, NetworkError>
    
    /// 유저가 투표한 후보들의 id 리스트 조희
    func getVotedCadidateList(userId: String) -> AnyPublisher<VotedCandidateListEntity, NetworkError>
    
    /// 투표 실행
    func postVote(candidate: VoteRequest) -> AnyPublisher<Data, NetworkError>
}

//
//  VoteType.swift
//  Union
//
//  Created by 박서연 on 1/27/25.
//

import Foundation

/// 투표 관련 유저 API 요청 타입 정의
enum VoteType: TargetType {
    /// 후보자 상세 정보 조회
    case getCandidateDetailInfo(candidateID: Int, voterID: String)
    /// 후보자 목록 조회
    case getCandidateList(pageable: PageableRequestDTO)
    /// 유저가 투표한 후보자 목록 조회
    case getVotedCandidateList(userID: String)
    /// 투표 실행
    case postVote(candidate: VoteRequestDTO)
    
    var url: String {
        switch self {
        case .getCandidateDetailInfo:
            return EndPoint.getCandidateDetail.url
        case .getCandidateList:
            return EndPoint.getCandidateList.url
        case .getVotedCandidateList:
            return EndPoint.votedCandidateList.url
        case .postVote:
            return EndPoint.vote.url
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getCandidateDetailInfo, .getCandidateList, .getVotedCandidateList:
            return .get
        case .postVote:
            return .post
        }
    }
    
    var query: Encodable? {
        switch self {
        case .getCandidateDetailInfo(_, let voterID):
            return ["userId" : voterID]
        case .getCandidateList(let pageable):
            return pageable
        case .getVotedCandidateList(let userID):
            return ["userId" : userID]
        case .postVote:
            return nil
        }
    }
    
    var path: String? {
        switch self {
        case .getCandidateDetailInfo(let candidateID, _):
            return "\(candidateID)"
        case .getCandidateList, .getVotedCandidateList, .postVote:
            return nil
        }
    }
    
    var body: Encodable? {
        switch self {
        case .getCandidateDetailInfo, .getCandidateList, .getVotedCandidateList:
            return nil
        case .postVote(let candidate):
            return candidate
        }
    }
}

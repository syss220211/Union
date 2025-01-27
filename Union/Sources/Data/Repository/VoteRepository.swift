//
//  VoteRepository.swift
//  Union
//
//  Created by 박서연 on 1/26/25.
//

import Foundation
import Combine
import SwiftUI

/// 투표 관련 네트워크 요청을 처리하는 VoteUsecase 구현체입니다.
final class VoteRepository: VoteRepositoryProtocol {
    
    private let networkService: NetworkService = .shared
    private var cancellables = Set<AnyCancellable>()
    
    init() { }
    
    /// 후보자 상제정보 조회
    func getCandidateDetailInfo(request: VoteType) -> AnyPublisher<CandidateDetailEntity, NetworkError> {
        return networkService.request(target: request)
            .tryMap { dto in
                CandidateDetailMapper.toCandidateDetail(response: dto)
            }
            .mapError{ error in
                return NetworkError.badMapper
            }
            .eraseToAnyPublisher()
    }
    
    /// 후보자 리스트 조회
    func getCandidateList(request: VoteType) -> AnyPublisher<CandidateListEntity, NetworkError> {
        return networkService.request(target: request)
            .tryMap { dto in
                CandidateListMapper.toCandidateListEntity(dto: dto)
            }
            .mapError { mapper in
                return NetworkError.badMapper
            }
            .eraseToAnyPublisher()
    }
    
    /// 유저가 투표한 후보자들의 id 리스트 조회
    func getVotedCadidateList(request: VoteType) -> AnyPublisher<VotedCandidateListEntity, NetworkError> {
        return networkService.request(target: request)
            .map { votedListDTO in
                VoteCandidateMapper.toVotedCandidateList(response: votedListDTO)
            }
            .mapError { error in
                return NetworkError.badMapper
            }
            .eraseToAnyPublisher()
    }
    
    /// 투표
    func postVote(request: VoteType) -> AnyPublisher<Data, NetworkError> {
        /// 성공 시 빈데이터 반환, 실패시 에러코드+에러문구 반환
        return networkService.request(target: request)
            .mapError { error in
                // 에러가 발생하는 경우, 투표자에게 알림을 주기 위해서 에러 처리 진행
                switch error {
                case .serverError(let statusCode, let data):
                    // 에러 발생 후 VoteResultDTO로 디코딩이 되는 경우, 투표 시 발생한 에러로 처리
                    if let serverError = try? JSONDecoder().decode(VoteResultDTO.self, from: data) {
                        let mappedData = VoteResultMapper.toVotedCandidateList(response: serverError)
                        return NetworkError.voteError(statusCode: statusCode, data: mappedData)
                    }
                    
                    // VoteResultDTO으로 디코딩 실패인 경우 Unknown
                    return .unknown
                    
                default:
                    return NetworkError.unknown
                }
            }
            .eraseToAnyPublisher()
    }
}

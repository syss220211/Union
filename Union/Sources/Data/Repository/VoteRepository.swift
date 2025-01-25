//
//  VoteRepository.swift
//  Union
//
//  Created by 박서연 on 1/26/25.
//

import Foundation
import Combine

final class VoteRepository: VoteRepositoryProtocol {
    
    private let networkService: NetworkService
    private var cancellables = Set<AnyCancellable>()
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
//    func getCandidateDetailInfo() -> AnyPublisher<CandidateDetailDTO, NetworkError> {
//        return 
//    }
//    
//    func getCandidateList() -> AnyPublisher<CandidateListDTO, NetworkError> {
//        return .Failure
//    }
    
    func getVotedCadidateList(userId: String) -> AnyPublisher<VotedCandidateListEntity, NetworkError> {
        let parameter: [String : String] = ["userId" : userId]
        
        return networkService.request(
            url: EndPoint.votedCandidateList.url,
            method: .get,
            queryParameters: parameter
        )
        .tryMap { votedListDTO -> VotedCandidateListEntity in
            return VoteCandidateMapper.toVotedCandidateList(response: votedListDTO)
        }
        .mapError { error in
            return (error as? NetworkError) ?? NetworkError.badMapper
        }
        .eraseToAnyPublisher()
    }
    
//    func postVote(candidate: CandidateRequest) -> AnyPublisher<VoteResultDTO, NetworkError> {
//        return .Failure
//    }
}

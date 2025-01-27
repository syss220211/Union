//
//  VoteRepository.swift
//  Union
//
//  Created by 박서연 on 1/26/25.
//

import Foundation
import Combine
import SwiftUI

final class VoteRepository: VoteRepositoryProtocol {
    
    private let networkService: NetworkService
    private var cancellables = Set<AnyCancellable>()
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func getCandidateDetailInfo(candidateID: Int, voterID: String) -> AnyPublisher<CandidateDetailEntity, NetworkError> {
        let parameter: [String : String] = ["userId" : voterID]
        
        return networkService.request(
            url: EndPoint.getCandidateDetail.url,
            method: .get,
            queryParameters: parameter,
            pathParameters: "\(candidateID)"
        )
        .tryMap { dto in
            CandidateDetailMapper.toCandidateDetail(response: dto)
        }
        .mapError{ error in
            return NetworkError.badMapper
        }
        .eraseToAnyPublisher()
        
    }
    
    func getCandidateList(pageable: PageableRequest, searchKeyworkd: String) -> AnyPublisher<CandidateListEntity, NetworkError> {
        var parameter: [String : String] = [:]
        parameter["page"] = "\(pageable.page)"
        parameter["size"] = "\(pageable.size)"
        parameter["searchKeyword"] = searchKeyworkd

        // sort가 비어 있으면 기본값으로 설정
        if pageable.sort.isEmpty {
                    parameter["sort"] = "string"
        } else {
            for sortValue in pageable.sort {
                parameter["sort"] = sortValue
            }
        }
        
        return networkService.request(
            url: EndPoint.getCandidateList.url,
            method: .get,
            queryParameters: parameter
        )
        .tryMap { dto in
            CandidateListMapper.toCandidateListEntity(dto: dto)
        }
        .mapError { mapper in
            return NetworkError.badMapper
        }
        .eraseToAnyPublisher()
    }
    
    func getVotedCadidateList(userId: String) -> AnyPublisher<VotedCandidateListEntity, NetworkError> {
        let parameter: [String : String] = ["userId" : userId]
        
        return networkService.request(
            url: EndPoint.votedCandidateList.url,
            method: .get,
            queryParameters: parameter
        )
        .map { votedListDTO in
            VoteCandidateMapper.toVotedCandidateList(response: votedListDTO)
        }
        .mapError { error in
            return NetworkError.badMapper
        }
        .eraseToAnyPublisher()
    }
    
    func postVote(candidate: VoteRequest) -> AnyPublisher<Data, NetworkError> {
        /// 성공 시 빈데이터 반환, 실패시 에러코드+에러문구 반환
        return networkService.request(
            url: EndPoint.vote.url,
            method: .post,
            body: candidate
        )
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
                print("unknownerror: \(error.localizedDescription)")
                return NetworkError.unknown
            }
        }
        .eraseToAnyPublisher()
    }
}

class testVM: ObservableObject {
    @Published var data: CandidateListEntity?
    @Published var ddata: VoteResultEntity?
    private var cancellables = Set<AnyCancellable>()
    let usecase = VoteUsecase(voteRepoProtocol: VoteRepository(networkService: NetworkService()))
    
    func get() {
        let pageable = PageableRequest(page: 0, size: 1, sort: ["voteCnt,DESC","name,ASC", "candidateNumber,ASC"])
        
        usecase.getCandidateList(pageable: pageable, searchKeyworkd: "Gana")
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("error \(error.localizedDescription)")
                }
            } receiveValue: { entity in
                self.data = entity
            }
            .store(in: &cancellables)
    }
    
    func post() {
        let request = VoteRequest(userId: "162dC", id: 58)
        
        usecase.postVote(candidate: request)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("finished")
                    break
                case .failure(let error):
                    switch error {
                    case .voteError(let statusCode, let data):
                        self.ddata = data
                    default:
                        print("투표 중 에러가 발생하였습니다.")
                    }
                }
            } receiveValue: { entity in
                print("receive;;")
                print("receivetype: \(type(of: entity))")
                print("data \(entity)")
            }
            .store(in: &cancellables)
    }
}

struct testView: View {
    
    @StateObject var vm = testVM()
    
    var body: some View {
        VStack{
            Text("test")
                .onTapGesture {
                    vm.post()
                }
            Text("\(vm.ddata)")
            
            Text("get")
                .onTapGesture {
                    vm.get()
                }

            Text("\(vm.data)")
        }
    }
}

#Preview {
    testView()
}

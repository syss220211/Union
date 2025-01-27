//
//  NetworkTest.swift
//  Union
//
//  Created by 박서연 on 1/27/25.
//

import SwiftUI
import Combine

class testVM: ObservableObject {
    @Published var getCandidateList: CandidateListEntity?
    @Published var postVote: VoteResultEntity?
    @Published var getCandidateDetailInfo: CandidateDetailEntity?
    @Published var TgetCandidateDetailInfo: CandidateDetailEntity?
    @Published var getVotedCadidateList: VotedCandidateListEntity?
    
    private var cancellables = Set<AnyCancellable>()
    let usecase = VoteUsecase(voteRepoProtocol: VoteRepository())
    
    
    func getCandidateListTest() {
        let pageableRequest = PageableRequestDTO(page: 1, size: 10, sort: ["name", "age"], searchKeyword: "John")
        usecase.getCandidateList(request: .getCandidateList(pageable: pageableRequest))
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("error \(error.localizedDescription)")
                }
            } receiveValue: { entity in
                self.getCandidateList = entity
            }
            .store(in: &cancellables)
    }
    
    func getVotedCadidateListTest() {
        usecase.getVotedCadidateList(request: .getVotedCandidateList(userID: "userA"))
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("\(error.localizedDescription)")
                }
            } receiveValue: { entity in
                self.getVotedCadidateList = entity
            }
            .store(in: &cancellables)
    }
    
    func getCandidateDetailInfoTest() {
        usecase.getCandidateDetailInfo(request: .getCandidateDetailInfo(candidateID: 58, voterID: "userA"))
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("\(error.localizedDescription)")
                }
            } receiveValue: { entity in
                self.getCandidateDetailInfo = entity
            }
            .store(in: &cancellables)
    }
    
    func voted() {
        let request = VoteRequestDTO(userId: "182dC", id: 58)
        usecase.postVote(request: .postVote(candidate: request))
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("finished")
                    break
                case .failure(let error):
                    switch error {
                    case .voteError(let statusCode, let data):
                        self.postVote = data
                        print("statusCode \(statusCode)")
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
        ScrollView {
            
            
            Button("getVotedCadidateListTest") {
                vm.getVotedCadidateListTest()
            }
            Text("\(vm.getVotedCadidateList)")
            
            Button("getCandidateListTest") {
                vm.getCandidateListTest()
            }
            Text("\(vm.getCandidateList)")
            
            Button("getCandidateDetailInfoTest") {
                vm.getCandidateDetailInfoTest()
            }
            Text("\(vm.getCandidateDetailInfo)")
            
            Button("getVotedCadidateListTest") {
                vm.voted()
            }
            Text("\(vm.postVote)")
        }
    }
}

#Preview {
    testView()
}


//
//  CandidateListEntity.swift
//  Union
//
//  Created by 박서연 on 1/26/25.
//

import Foundation

struct CandidateListEntity {
    let totalPages: Int
    let totalElements: Int
    let size: Int
    let content: [CandidateContentEntity]
    let number: Int
    let sort: SortEntity
    let pageable: PageableEntity
    let numberOfElements: Int
    let first: Bool
    let last: Bool
    let empty: Bool
}

struct CandidateContentEntity: Decodable {
    let id: Int
    let candidateNumber: Int
    let name: String
    let profileUrl: String
    let voteCnt: String
    var voted: Bool = false
}

struct SortEntity: Decodable {
    let empty: Bool
    let sorted: Bool
    let unsorted: Bool
}

struct PageableEntity: Decodable {
    let offset: Int
    let sort: SortEntity
    let pageNumber: Int
    let pageSize: Int
    let paged: Bool
    let unpaged: Bool
}

extension CandidateListEntity {
    func updatingContent(with newContent: [CandidateContentEntity]) -> CandidateListEntity {
        return CandidateListEntity(
            totalPages: self.totalPages,
            totalElements: self.totalElements,
            size: self.size,
            content: newContent,
            number: self.number,
            sort: self.sort,
            pageable: self.pageable,
            numberOfElements: self.numberOfElements,
            first: self.first,
            last: self.last,
            empty: self.empty
        )
    }
}

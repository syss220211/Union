//
//  CandidateListDTO.swift
//  Union
//
//  Created by 박서연 on 1/26/25.
//

import Foundation

struct CandidateListDTO: Decodable {
    let totalPages: Int?
    let totalElements: Int?
    let size: Int?
    let content: [CandidateContentDTO]?
    let number: Int?
    let sort: SortDTO?
    let pageable: PageableDTO?
    let numberOfElements: Int?
    let first: Bool?
    let last: Bool?
    let empty: Bool?
}

struct CandidateContentDTO: Decodable {
    let id: Int?
    let candidateNumber: Int?
    let name: String?
    let profileUrl: String?
    let voteCnt: Int?
}

struct SortDTO: Decodable {
    let empty: Bool?
    let sorted: Bool?
    let unsorted: Bool?
}

struct PageableDTO: Decodable {
    let offset: Int?
    let sort: SortDTO?
    let pageNumber: Int?
    let pageSize: Int?
    let paged: Bool?
    let unpaged: Bool?
}

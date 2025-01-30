//
//  VotedCandidateListDTO.swift
//  Union
//
//  Created by 박서연 on 1/26/25.
//

import Foundation

struct VotedCandidateListDTO: Decodable {
    let candidates: [Int]?
    
    init(from decoder: Decoder) throws {
        // JSON 배열 자체를 디코딩
        let container = try decoder.singleValueContainer()
        self.candidates = try container.decode([Int].self)
    }
}

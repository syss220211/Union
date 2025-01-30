//
//  VotedCandidateListEntity.swift
//  Union
//
//  Created by 박서연 on 1/26/25.
//

import Foundation

struct VotedCandidateListEntity {
    let candidates: [Int]
    
    init(candidates: [Int]) {
        self.candidates = candidates
    }
}

//
//  VoteCandidateMapper.swift
//  Union
//
//  Created by 박서연 on 1/26/25.
//

import Foundation

final class VoteCandidateMapper {
    static func toVotedCandidateList(response: VotedCandidateListDTO) -> VotedCandidateListEntity {
        return VotedCandidateListEntity(
            candidates: response.candidates ?? []
        )
    }
}

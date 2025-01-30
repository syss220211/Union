//
//  VoteResultMapper.swift
//  Union
//
//  Created by 박서연 on 1/26/25.
//

import Foundation

final class VoteResultMapper {
    static func toVotedCandidateList(response: VoteResultDTO) -> VoteResultEntity {
        return VoteResultEntity(
            errorCode: response.errorCode ?? "",
            errorMessage: response.errorMessage ?? ""
        )
    }
}

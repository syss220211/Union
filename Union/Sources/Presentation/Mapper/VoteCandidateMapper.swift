//
//  VoteCandidateMapper.swift
//  Union
//
//  Created by 박서연 on 1/26/25.
//

import Foundation

final class CandidateDetailMapper {
    static func toCandidateDetail(response: CandidateDetailDTO) -> CandidateDetailEntity {
        return CandidateDetailEntity(
            id: response.id ?? 0,
            candidateNumber: response.candidateNumber ?? 0,
            name: response.name ?? "",
            country: response.country ?? "",
            education: response.education ?? "",
            major: response.major ?? "",
            hobby: response.hobby ?? "",
            talent: response.talent ?? "",
            ambition: response.ambition ?? "",
            contents: response.contents ?? "",
            profileInfoList: (response.profileInfoList ?? []).compactMap({ dto in
                ProfileInfoListEntity(
                    fileArea: dto.fileArea ?? 0,
                    displayOrder: dto.displayOrder ?? 0,
                    profileUrl: dto.profileUrl ?? "",
                    mimeType: dto.mimeType ?? ""
                )
            }),
            regDt: response.regDt ?? "",
            voted: response.voted ?? false
        )
    }
}

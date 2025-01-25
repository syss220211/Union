//
//  CandidateDetailEntity.swift
//  Union
//
//  Created by 박서연 on 1/26/25.
//

import Foundation

struct CandidateDetailEntity {
    let id: Int
    let candidateNumber: Int
    let name: String
    let country: String
    let education: String
    let major: String
    let hobby: String
    let talent: String
    let ambition: String
    let contents: String
    let profileInfoList: [ProfileInfoListEntity]
    let regDt: String
    let voted: Bool
}

struct ProfileInfoListEntity {
    let fileArea: Int
    let displayOrder: Int
    let profileUrl: String
    let mimeType: String
}

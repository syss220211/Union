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
    var voted: Bool
}

struct ProfileInfoListEntity {
    let id = UUID().uuidString
    let fileArea: Int
    let displayOrder: Int
    let profileUrl: String
    let mimeType: String
}

extension CandidateDetailEntity {
    var details: [(title: String, content: String)] {
        [
            ("Education", education),
            ("Major", major),
            ("Hobby", hobby),
            ("Talent", talent),
            ("Ambition", ambition)
        ]
    }
}

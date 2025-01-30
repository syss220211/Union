//
//  EndPoint.swift
//  Union
//
//  Created by 박서연 on 1/25/25.
//

import Foundation

struct BaseUrl {
    static let baseURL = "https://api-wmu-dev.angkorcoms.com"
}

enum EndPoint: String {
    case getCandidateList = "/vote/candidate/list"
    case getCandidateDetail = "/vote/candidate"
    case votedCandidateList = "/vote/voted/candidate/list"
    case vote = "/vote"
    
    var url: String {
        return BaseUrl.baseURL + self.rawValue
    }
}

//
//  VoteResultDTO.swift
//  Union
//
//  Created by 박서연 on 1/26/25.
//

import Foundation

struct VoteResultDTO: Decodable {
    let errorCode: String?
    let errorMessage: String?
    
    private enum CodingKeys: String, CodingKey {
        case errorCode
        case errorMessage
    }
}

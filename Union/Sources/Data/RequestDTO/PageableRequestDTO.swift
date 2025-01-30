//
//  PageableRequest.swift
//  Union
//
//  Created by 박서연 on 1/26/25.
//

import Foundation

struct PageableRequestDTO: Encodable {
    let page: Int
    let size: Int
    let sort: [String]
    let searchKeyword: String?
}

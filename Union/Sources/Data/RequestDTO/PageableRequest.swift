//
//  PageableRequest.swift
//  Union
//
//  Created by 박서연 on 1/26/25.
//

import Foundation

struct PageableRequest {
    let page: Int
    let size: Int
    let sort: [String]
}

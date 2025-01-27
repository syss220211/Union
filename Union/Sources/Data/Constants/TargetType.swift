//
//  TargetType.swift
//  Union
//
//  Created by 박서연 on 1/27/25.
//

import Foundation

protocol TargetType {
    var url: String { get }
    var method: HTTPMethod { get }
    var path: String? { get }
    var query: Encodable? { get }
    var body: Encodable? { get }
}

//
//  Error.swift
//  Union
//
//  Created by 박서연 on 1/25/25.
//

import Foundation

enum NetworkError: Error {
    case badRequest
    case badResponse
    /// 500-599 error
    case serverError(statusCode: Int)
    case unknown
    case decodingError
    case invalidURL
    case queryParameterError
    case bodyError
    case badMapper
}

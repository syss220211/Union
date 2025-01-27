//
//  Error.swift
//  Union
//
//  Created by 박서연 on 1/25/25.
//

import Foundation

enum NetworkError: Error {
    /// HTTPUrlResponse 생성 실패
    case badResponse(message: String?)
    /// 400 Error
    case badRequest(message: String?)
    /// 401 Error
    case unauthorized(message: String?)
    /// 404
    case notFound(message: String?)
    /// 409 Conflic
    case conflict(message: String?)
    /// 400 ~ 499 사이 error
    /// 투표 중 발생한 에러를 처리하는 에러
    case voteError(statusCode: Int, data: VoteResultEntity)// data: Data?, decoded: VoteResultEntity)
    /// 500 ~ 599 Error
    case serverError(statusCode: Int, data: Data)
    /// unknown Error
    case unknown
    /// Decoding 에러
    case decodingError
    /// 잘못된 URL
    case invalidURL
    
    /// URLSession과 관련된 에러
    /// 쿼리 파라미터 추가 실패
    case queryParameterError
    /// 바디 설정 실패
    case bodyError
    /// Mapper Error
    case badMapper
}

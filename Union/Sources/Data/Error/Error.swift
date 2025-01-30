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


enum StatusCode: Int, CaseIterable {
    ///You have exceeded the maximum number of allowed votes.
    case code400 = 400
    /// This candidate is not exist.
    case code401 = 401
    /// This candidate is not exist.
    case code404 = 404
    /// You already voted.
    case code409 = 409
    
    var code: Int {
        switch self {
        case .code400:
            return 400
        case .code401:
            return 401
        case .code404:
            return 404
        case .code409:
            return 409
        }
    }
    
    var message: String {
        switch self {
        case .code400:
            return "허용된 최대 투표 수를 초과할 수 없습니다."
        case .code401:
            return "해당 후보자는 존재하지 않습니다."
        case .code404:
            return "해당 후보자는 존재하지 않습니다."
        case .code409:
            return "이미 투표한 후보자입니다."
        }
    }
    
    /// 숫자 상태 코드를 기반으로 메시지를 반환하는 메서드
    static func message(forCode code: Int) -> String? {
        guard let statusCode = StatusCode(rawValue: code) else {
            return nil /// 유효한 상태 코드가 아닐 경우 nil 반환
        }
        return statusCode.message
    }
}

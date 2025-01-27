//
//  NetworkService.swift
//  Union
//
//  Created by 박서연 on 1/25/25.
//

import Foundation
import Combine

final class NetworkService {
    
    // NetworkService 싱글톤 객체 생성
    public static let shared: NetworkService = NetworkService()
    public var cancellables = Set<AnyCancellable>()
    
    /// 서버 요청 메서드
    /// - Parameter target: API 요청을 위한 타겟
    /// - Returns: API 호출 결과를 반환하는 Publisher
    func request<T: Decodable>(
        target: TargetType
    ) -> AnyPublisher<T, NetworkError> {
        do {
            // URLRequest 객체 생성
            let request = try createRequest(
                url: target.url,
                method: target.method,
                queryParameters: target.query,
                pathParameters: target.path,
                body: target.body
            )
            
            // 생성된 URLRequest를 사용하여 요청 실행
            return performRequest(request: request)
        } catch {
            // 요청 생성 실패 시, 오류를 반환
            return Fail(
                error: NetworkError.badRequest(
                    message: "[400] 잘못된 요청입니다."
                )
            ).eraseToAnyPublisher()
        }
    }
}

extension NetworkService {
    
    /// URLRequest를 생성하는 메서드
    /// - Parameters:
    ///   - url: 요청 URL
    ///   - method: HTTP 메서드 (GET, POST 등)
    ///   - queryParameters: URL 쿼리 파라미터
    ///   - pathParameters: URL 경로 파라미터
    ///   - body: HTTP 요청 본문 (POST, PUT 등에 사용)
    /// - Returns: 생성된 URLRequest 객체
    /// - Throws: URLRequest 생성 중 오류가 발생하면 오류를 던짐
    private func createRequest(
        url: String,
        method: HTTPMethod,
        queryParameters: Encodable? = nil,
        pathParameters: String? = nil,
        body: Encodable? = nil
    ) throws -> URLRequest {
        var urlString = url
        
        // 경로 파라미터가 있을 경우 URL에 추가
        if let pathParameters = pathParameters {
            urlString += "/\(pathParameters)"
        }
        
        // URL 생성
        guard var components = URLComponents(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        // 쿼리 파라미터가 있을 경우, 이를 URL에 추가
        if let parameters = queryParameters {
            let queryItems = try createQueryItems(from: parameters)
            components.queryItems = (components.queryItems ?? []) + queryItems
        }
        
        // 최종 URL을 생성
        guard let finalURL = components.url else {
            throw NetworkError.invalidURL
        }
        
        // URLRequest 생성
        var urlRequest = URLRequest(url: finalURL)
        urlRequest.httpMethod = method.rawValue
        
        // 본문 설정 (POST나 PUT 등에서 사용)
        if let body = body {
            do {
                let encoder = JSONEncoder()
                let httpBody = try encoder.encode(body)
                urlRequest.httpBody = httpBody
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                throw NetworkError.bodyError
            }
        }
        
        return urlRequest
    }
    
    /// 주어진 파라미터를 URLQueryItem 배열로 변환하는 메서드
    /// - Parameter parameters: 변환할 파라미터
    /// - Returns: URLQueryItem 배열
    /// - Throws: 변환 중 오류가 발생하면 오류를 던짐
    private func createQueryItems(from parameters: Encodable) throws -> [URLQueryItem] {
        // 파라미터가 [String: String] 타입인 경우 간단히 처리
        if let dictionary = parameters as? [String: String] {
            return dictionary.map { URLQueryItem(name: $0.key, value: $0.value) }
        } else {
            // 그 외의 경우, Mirror를 사용해 속성들을 추출하여 URLQueryItem으로 변환
            let mirror = Mirror(reflecting: parameters)
            var queryItems: [URLQueryItem] = []
            
            for (label, value) in mirror.children {
                guard let label = label else { continue }
                
                // 배열 값이 있을 경우, 각각에 대해 URLQueryItem을 생성
                if let arrayValue = value as? [Any] {
                    for item in arrayValue {
                        queryItems.append(URLQueryItem(name: label, value: "\(item)"))
                    }
                // Optional 값일 경우 처리 (옵셔널의 값을 확인 후 쿼리 파라미터로 추가)
                } else if let optionalValue = value as? OptionalProtocol, optionalValue.hasValue {
                    queryItems.append(URLQueryItem(name: label, value: "\(optionalValue.wrappedValue)"))
                } else if !(value is OptionalProtocol) {
                    queryItems.append(URLQueryItem(name: label, value: "\(value)"))
                }
            }
            
            return queryItems
        }
    }
    
    /// URLRequest를 사용하여 API 호출을 수행하는 메서드
    /// - Parameter request: 요청에 사용할 URLRequest
    /// - Returns: 응답 데이터를 디코딩하여 반환하는 Publisher
    private func performRequest<T: Decodable>(request: URLRequest) -> AnyPublisher<T, NetworkError> {
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { result in
                // HTTP 응답 검증
                guard let httpResponse = result.response as? HTTPURLResponse else {
                    throw NetworkError.badResponse(message: "HTTPURLResponse 생성에 실패하였습니다.")
                }
                
                // 상태 코드가 200~299 사이가 아닌 경우, 오류 발생
                if !(200...299).contains(httpResponse.statusCode) {
                    print("statusCode \(httpResponse.statusCode)")
                    throw NetworkError.serverError(statusCode: httpResponse.statusCode, data: result.data)
                }
                
                // 만약 응답 데이터가 비어 있으면 빈 Data 객체 반환
                if result.data.isEmpty {
                    return Data()
                }
                
                // 200~299 상태 코드일 경우, 데이터를 반환
                return result.data
            }
            .map { data -> AnyPublisher<T, NetworkError> in
                // 빈 데이터인 경우, 빈 Publisher를 반환
                if data.isEmpty {
                    return Empty<T, NetworkError>()
                        .eraseToAnyPublisher()
                } else {
                    // 데이터를 디코딩하여 반환
                    return Just(data)
                        .decode(type: T.self, decoder: JSONDecoder())
                        .mapError { _ in NetworkError.decodingError }
                        .eraseToAnyPublisher()
                }
            }
            .mapError { error -> NetworkError in
                // 오류 발생 시 적절한 NetworkError 반환
                if let networkError = error as? NetworkError {
                    return networkError
                }
                return NetworkError.unknown
            }
            .switchToLatest() // 두 개의 Publisher 중 최신을 구독하여 처리
            .eraseToAnyPublisher()
    }
}

/// Optional 값을 처리하기 위한 프로토콜
protocol OptionalProtocol {
    var hasValue: Bool { get }
    var wrappedValue: Any { get }
}

extension Optional: OptionalProtocol {
    var hasValue: Bool {
        self != nil
    }
    
    var wrappedValue: Any {
        switch self {
        case .some(let value):
            return value
        case .none:
            return ()
        }
    }
}


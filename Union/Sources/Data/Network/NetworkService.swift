//
//  NetworkService.swift
//  Union
//
//  Created by 박서연 on 1/25/25.
//

import Foundation
import Combine

final class NetworkService {
    public var cancellables = Set<AnyCancellable>()
    init() { }
    
    /// 서버 요청 메서드
    func request<T: Decodable>(
        url: String,
        method: HTTPMethod,
        queryParameters: Encodable? = nil,
        pathParameters: String? = nil,
        body: Encodable? = nil
    ) -> AnyPublisher<T, NetworkError> {
        do {
            let request = try createRequest(
                url: url,
                method: method,
                queryParameters: queryParameters,
                pathParameters: pathParameters,
                body: body
            )
            
            return performRequest(request: request)
        } catch {
            return Fail(error: NetworkError.badRequest).eraseToAnyPublisher()
        }
    }
}

extension NetworkService {
    /// URLRequest 생성 함수
    private func createRequest(
        url: String,
        method: HTTPMethod,
        queryParameters: Encodable? = nil,
        pathParameters: String? = nil,
        body: Encodable? = nil
    ) throws -> URLRequest {
        var url = url
        
        /// PathParameter 추가
        if let pathParameters = pathParameters {
            url = url + "\(pathParameters)"
        }
        
        /// url 생성
        guard var url = URL(string: url) else {
            throw NetworkError.invalidURL
        }
        
        /// queryParamter 추가
        if let parameters = queryParameters {
            guard let queryDictionary = try? parameters.toDictionary() else {
                throw NetworkError.queryParameterError
            }
            
            var queryItems: [URLQueryItem] = []
            
            queryDictionary.forEach({ key, value in
                queryItems.append(URLQueryItem(name: key, value: "\(value)"))
            })
            
            url.append(queryItems: queryItems)
        }
        
        /// URLRequest 생성
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        /// body 설정
        if let body = body {
            do {
                let httpBody = try JSONEncoder().encode(body)
                urlRequest.httpBody = httpBody
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                throw NetworkError.bodyError
            }
        }
        
        return urlRequest
    }
    
    /// 공통 처리 로직
    private func performRequest<T: Decodable>(request: URLRequest) -> AnyPublisher<T, NetworkError> {
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { result in
                guard let httpResponse = result.response as? HTTPURLResponse else {
                    throw NetworkError.badResponse
                }
                
                /// 성공이 아닌 경우 처리
                if !(200...299).contains(httpResponse.statusCode) {
                    throw NetworkError.serverError(statusCode: httpResponse.statusCode)
                }
                
                return result.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                if let networkError = error as? NetworkError {
                    return networkError
                }
                
                return NetworkError.unknown
            }
            .eraseToAnyPublisher()
    }
}

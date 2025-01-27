//
//  NetworkService.swift
//  Union
//
//  Created by 박서연 on 1/25/25.
//

import Foundation
import Combine

final class NetworkService {
    public static let shared: NetworkService = NetworkService()
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
            return Fail(
                error: NetworkError.badRequest(
                    message: "[400] 잘못된 요청입니다."
                )
            ).eraseToAnyPublisher()
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
            
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
            if components == nil {
                throw NetworkError.invalidURL
            }

            var queryItems: [URLQueryItem] = components?.queryItems ?? []
            
            queryDictionary.forEach { key, value in
                queryItems.append(URLQueryItem(name: key, value: "\(value)"))
            }
            
            components?.queryItems = queryItems
            
            guard let updatedURL = components?.url else {
                throw NetworkError.invalidURL
            }
            url = updatedURL
        }
        
        /// URLRequest 생성
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        /// body 설정
        if let body = body {
            do {
                let encoder = JSONEncoder()
                let httpBody = try encoder.encode(body)
                urlRequest.httpBody = httpBody
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
//                // 직렬화된 JSON을 문자열로 확인
//                if let jsonString = String(data: httpBody, encoding: .utf8) {
//                    debugPrint("🚨🚨 <<<HTTP BODY JSON>>> \(jsonString) 🚨🚨")
//                } else {
//                    debugPrint("🚨🚨 <<<HTTP BODY JSON ERROR>>> Could not convert to string 🚨🚨")
//                }
                
            } catch {
                throw NetworkError.bodyError
            }
        }
        
        return urlRequest
    }
   
    private func performRequest<T: Decodable>(request: URLRequest) -> AnyPublisher<T, NetworkError> {
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { result in
                guard let httpResponse = result.response as? HTTPURLResponse else {
                    throw NetworkError.badResponse(message: "HTTPURLResponse 생성에 실패하였습니다.")
                }
                
                if !(200...299).contains(httpResponse.statusCode) {
                    print("statusCode \(httpResponse.statusCode)")
                    throw NetworkError.serverError(statusCode: httpResponse.statusCode, data: result.data)
                }
                
                /// 만약 응답 데이터가 빈 경우 빈Data() 객체 반환
                if result.data.isEmpty {
                    return Data()
                }
                
                /// 200-299 사이인 경우, 성공했을 때 data 리턴 후 디코딩 진행
                return result.data
            }
            .map { data -> AnyPublisher<T, NetworkError> in
                /// tryMap에서 반환된 데이터를 받아 data.isEmpty 여부에 따라 다른 동작을 수행함
                if data.isEmpty {
                    /// 빈데이터가 반환된 경우(성공) 아무값도 방출하지 않는 EmptyPublisher 반환
                    return Empty<T, NetworkError>()
                        .eraseToAnyPublisher()
                } else {
                    return Just(data)
                        .decode(type: T.self, decoder: JSONDecoder())
                        .mapError { _ in NetworkError.decodingError }
                        .eraseToAnyPublisher()
                }
            }
            .mapError { error -> NetworkError in
            /// tryMap, dataTaskPublisher 가 실패하는 경우 오류 처리를 위한 MapError
                if let networkError = error as? NetworkError {
                    return networkError
                }
                return NetworkError.unknown
            }
            .switchToLatest() /// map 에서 반환된 publisher를 구독하여 결과를 처리할 때 사용함 (두 케이스 중 최신의 publisher를 구독하게 함)
            .eraseToAnyPublisher()
    }


    
    // MARK: - 일단 성공
//    private func performRequest<T: Decodable>(request: URLRequest) -> AnyPublisher<T, NetworkError> {
//        URLSession.shared.dataTaskPublisher(for: request)
//            .tryMap { result -> Data in
//                guard let httpResponse = result.response as? HTTPURLResponse else {
//                    throw NetworkError.badResponse(message: "HTTPURLResponse 생성에 실패하였습니다.")
//                }
//                
//                if !(200...299).contains(httpResponse.statusCode) {
//                    print("statusCode \(httpResponse.statusCode)")
//                    throw NetworkError.serverError(statusCode: httpResponse.statusCode, data: result.data)
//                }
//                
//                if result.data.isEmpty {
//                    return Data()
//                }
//                
//                return result.data
//            }
//            .map { data -> AnyPublisher<T, NetworkError> in
//                if data.isEmpty {
//                    return Empty<T, NetworkError>()
//                        .eraseToAnyPublisher()
//                } else {
//                    return Just(data)
//                        .decode(type: T.self, decoder: JSONDecoder())
//                        .mapError { _ in NetworkError.decodingError }
//                        .eraseToAnyPublisher()
//                }
//            }
//            .mapError { error -> NetworkError in
//                if let networkError = error as? NetworkError {
//                    return networkError
//                }
//                return NetworkError.unknown
//            }
//            .switchToLatest()
//            .eraseToAnyPublisher()
//    }
    
    /// 공통 처리 로직
//    private func performRequest<T: Decodable>(request: URLRequest) -> AnyPublisher<T, NetworkError> {
//        URLSession.shared.dataTaskPublisher(for: request)
//            .tryMap { result in
//                guard let httpResponse = result.response as? HTTPURLResponse else {
//                    throw NetworkError.badResponse
//                }
//                
//                ////🔴🔴🔴🔴
////                // 응답 데이터를 문자열로 변환하여 출력
////                debugPrint("🚨🚨 <<<Raw Response Data>>> 🚨🚨 \(String(data: result.data, encoding: .utf8) ?? "Unable to decode data")")
////                
////                do {
////                    // JSON으로 변환
////                    let jsonObject = try JSONSerialization.jsonObject(with: result.data, options: .mutableContainers)
////                    debugPrint("🚨🚨 <<<JSON Data>>> 🚨🚨 \(jsonObject)")
////                } catch {
////                    debugPrint("🚨🚨 <<<JSON Serialization Error>>> 🚨🚨 \(error.localizedDescription)")
////                    throw NetworkError.decodingError
////                }
//                ///🔴🔴🔴🔴
//                
//                
//                if result.data.isEmpty {
//                    print("선거 성공;;")
//                    return AnyPublisher(Empty(), NetworkError.)
//                }
//                
//                /// 성공이 아닌 경우 처리
//                if !(200...299).contains(httpResponse.statusCode) {
//                    throw NetworkError.serverError(statusCode: httpResponse.statusCode)
//                }
//                print("data \(result.data)")
//                print("data response \(result.response)")
//                return result.data
//            }
//            .decode(type: T.self, decoder: JSONDecoder())
//            .mapError { error in
//                if let networkError = error as? NetworkError {
//                    return networkError
//                }
//                print("decodingerror';;;;")
//                return NetworkError.decodingError
//            }
//            .eraseToAnyPublisher()
//    }
}

//
//  APIClient.swift
//  networking
//
//  Created by Esekiel Surbakti on 11/06/21.
//

import Foundation
import Combine

public class APIClient {
    
    public static let instance = APIClient()
    
    private init() {}
    
    public func requestHttp<T: Codable>(path: String,
                                          method: HTTPMethod,
                                          parameters: [String: Any]? = nil) -> AnyPublisher<T, APIError> {
        
        guard let request = createRequest(path: path, method: method, parameters: parameters) else {
            return Fail(error: APIError.invalidRequest).eraseToAnyPublisher()
        }
        
        print("request \(request)")
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .mapError{ error in
                self.handleError(error)
            }
            .flatMap { data, response -> AnyPublisher<T, APIError> in
                if let response = response as? HTTPURLResponse {
                    let statusCode = response.statusCode
                    if !(200...299).contains(statusCode) {
                        print("Status Code: \(statusCode)")
                        return Fail(error: self.httpError(statusCode)).eraseToAnyPublisher()
                    } else {
                        return Just(data)
                            .decode(type: T.self, decoder: JSONDecoder())
                            .mapError{ error in self.handleError(error)}
                            .eraseToAnyPublisher()
                    }
                }
                return Fail(error: APIError.unknownError).eraseToAnyPublisher()
                
            }.eraseToAnyPublisher()
    }
    
    private func createRequest(path: String,
                               method: HTTPMethod,
                               parameters: [String: Any]? = nil) -> URLRequest? {
        let urlString = APIContract.BASE_URL + path
        guard let url = URL(string: urlString) else { return nil }
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = method.rawValue
        
        if let params = parameters {
            switch method {
            case .get:
                var urlComponent = URLComponents(string: urlString)
                urlComponent?.queryItems = params.map { URLQueryItem(name: $0, value: "\($1)") }
                urlRequest.url = urlComponent?.url
            case .post, .delete, .patch:
                let bodyData = try? JSONSerialization.data(withJSONObject: params, options: [])
                urlRequest.httpBody = bodyData
            }
        }
        return urlRequest
    }
    
    private func httpError(_ statusCode: Int) -> APIError {
        switch statusCode {
        case 400: return .badRequest(statusCode)
        case 401: return .unauthorized(statusCode)
        case 403: return .forbidden(statusCode)
        case 404: return .notFound(statusCode)
        case 402, 405...499: return .error4xx(statusCode)
        case 500: return .serverError(statusCode)
        case 501...599: return .error5xx(statusCode)
        default: return .unknownError
        }
    }
    
    private func handleError(_ error: Error) -> APIError {
        switch error {
        case is DecodingError:
            return .decodingError
        case let urlError as URLError:
            return .urlSessionFailed(urlError)
        case let error as APIError:
            return error
        default:
            return .unknownError
        }
    }
}

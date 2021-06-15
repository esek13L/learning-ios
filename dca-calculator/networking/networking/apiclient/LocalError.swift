//
//  APIError.swift
//  networking
//
//  Created by Esekiel Surbakti on 14/06/21.
//

import Foundation

public struct RequestError {
    var errorDescription: String
    var errorCode: String
}

public enum APIError: LocalizedError {
    case invalidRequest
    case badRequest(_ code: Int)
    case unauthorized(_ code: Int)
    case forbidden(_ code: Int)
    case notFound(_ code: Int)
    case error4xx(_ code: Int)
    case serverError(_ code: Int)
    case error5xx(_ code: Int)
    case decodingError
    case urlSessionFailed(_ error: URLError)
    case unknownError
    
    public func value() -> RequestError {
        switch self {
        case .invalidRequest:
            return RequestError(errorDescription: "Invalid request", errorCode: "000")
        case .badRequest(let errorCode):
            return RequestError(errorDescription: "Bad request error", errorCode: String(errorCode))
        case .unauthorized(let errorCode):
            return RequestError(errorDescription: "Unauthorized error", errorCode: String(errorCode))
        case .forbidden(let errorCode):
            return RequestError(errorDescription: "Forbidden error", errorCode: String(errorCode))
        case .notFound(let errorCode):
            return RequestError(errorDescription: "Not found error", errorCode: String(errorCode))
        case .error4xx(let errorCode):
            return RequestError(errorDescription: "Error 4xx", errorCode: String(errorCode))
        case .serverError(let errorCode):
            return RequestError(errorDescription: "Server error", errorCode: String(errorCode))
        case .error5xx(let errorCode):
            return RequestError(errorDescription: "Error 5xx", errorCode: String(errorCode))
        case .decodingError:
            return RequestError(errorDescription: "decodingError", errorCode: "000")
        case .urlSessionFailed(let urlError):
            return RequestError(errorDescription: urlError.localizedDescription, errorCode: String(urlError.errorCode))
        default:
            return RequestError(errorDescription: "Unknown error", errorCode: "000")
        }
    }
}

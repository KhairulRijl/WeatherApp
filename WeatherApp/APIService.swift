//
//  APIService.swift
//  WeatherApp
//
//  Created by Khairul Rijal on 12/01/20.
//  Copyright © 2020 Khairul Rijal. All rights reserved.
//

import Foundation
import Moya
import Alamofire

//MARK: - Provider

//Bearer token
var token: String{
    get{
        return ""
    }
}

//Provider with bearer token
var authProvider: MoyaProvider<APIService>{
    get{
        return MoyaProvider<APIService>(plugins: [
            AccessTokenPlugin { () -> String in
                return token
                }
        ])
    }
}

//Normal Provider
let provider = MoyaProvider<APIService>()

//MARK: - List Type of Available API Service
enum APIService{
    case forecast5(String)
}

extension APIService: TargetType, AccessTokenAuthorizable{
    
    public var baseURL: URL { return URL(string: "https://api.openweathermap.org/data/2.5")! }
    
    public var path: String{
        switch self {
        case .forecast5:
            return "/forecast"
        }
        
    }
    
    public var method: Moya.Method{
        switch self {
        case .forecast5:
            return .get
        }
    }
    
    public var task: Task {
        switch self {
        case .forecast5(let zipCode):
            return .requestParameters(
                parameters: ["zip" : zipCode, "appid": "c1398406d45c67ea0ee8330266d3689a", "units": "metric"],
                encoding: CustomUrlEncoding())
        }
    }

    public var authorizationType: AuthorizationType {
        switch self {
        default:
            return .none
        }
    }
    
    public var validationType: ValidationType{
        return .successAndRedirectCodes
    }
    
    public var headers: [String : String]? {
        return [:]
    }
    
    public var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
}

struct CustomUrlEncoding : ParameterEncoding {
    
    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var urlRequest = try urlRequest.asURLRequest()

        guard let parameters = parameters else { return urlRequest }

            guard let url = urlRequest.url else {
                throw AFError.parameterEncodingFailed(reason: .missingURL)
            }

            if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
                let percentEncodedQuery = (urlComponents.percentEncodedQuery.map { $0 + "&" } ?? "") + query(parameters: parameters)
                urlComponents.percentEncodedQuery = percentEncodedQuery
                urlRequest.url = urlComponents.url
            }

        return urlRequest
    }

    private func query(parameters: Parameters) -> String {
        var components: [(String, String)] = []

        for key in parameters.keys.sorted(by: <) {
            let value = parameters[key]!
            components += queryComponents(fromKey: key, value: value)
        }
        return components.map { "\($0)=\($1)" }.joined(separator: "&")
    }

    public func queryComponents(fromKey key: String, value: Any) -> [(String, String)] {
        var components: [(String, String)] = []

        if let array = value as? [Any] {
            components.append((key, encode(array: array, separatedBy: ",")))
        } else {
            components.append((key, "\(value)"))
        }

        return components
    }

    private func encode(array: [Any], separatedBy separator: String) -> String {
        return array.map({"\($0)"}).joined(separator: separator)
    }
}

//
//  SWTargetType.swift
//  SWNetwork
//
//  Created by wangyang on 2020/12/30.
//

import Foundation
import Moya

enum SWTargetType {
    case request(SWRequestConfig)
}

extension SWTargetType : TargetType {
    var baseURL: URL {
        switch self {
        case .request(let config):
            return URL(string: config.baseURL)!
        }
    }
    
    var path: String {
        switch self {
        case .request(let config):
            return config.path
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .request(let config):
            return Method(rawValue: config.method.rawValue)!
        }
    }
    
    var sampleData: Data {
        switch self {
        case .request(let config):
            return config.sampleData
        }
    }
    
    var task: Task {
        switch self {
        case .request(let config):
            guard let params = config.params else { return .requestPlain }
            if config.encodingType == .URL {
                return .requestParameters(parameters: params, encoding: URLEncoding.default)
            }
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .request(let config):
            return config.headers
        }
    }
        
    var showLoading: Bool {
        switch self {
        case .request(let config):
            return config.showLoding
        }
    }
    
    /// 日志输出
    var logEnable: Bool {
        switch self {
        case .request(let config):
            return config.logEnable
        }
    }
}

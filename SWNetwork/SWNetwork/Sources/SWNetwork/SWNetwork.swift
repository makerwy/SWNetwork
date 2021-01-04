//
//  SWNetwork.swift
//  SWNetwork
//
//  Created by wangyang on 2020/12/31.
//

import Foundation
import RxSwift
import Moya

protocol NetworkProtocol {
    static func request(base: String,
                        path: String,
                        method: SWHttpMethod,
                        encodingType: SWEncodingType,
                        headers: [String: String]?,
                        params: [String: Any]?,
                        showLoading: Bool) -> Single<Moya.Response>
}

extension NetworkProtocol {
    static func request(base: String,
                        path: String,
                        method: SWHttpMethod,
                        encodingType: SWEncodingType,
                        headers: [String: String]?,
                        params: [String: Any]?,
                        showLoading: Bool) -> Single<Moya.Response> {
        let config = SWRequestConfig(baseURL: base,
                                     path: path,
                                     method: method,
                                     encodingType: encodingType,
                                     headers: headers,
                                     params: params,
                                     showLoding: showLoading)
        return Network.provider.rx
            .request(.request(config))
            .filterSuccessfulStatusCodes()
    }
}

protocol NetworkConfig {
    var timeoutInterval: TimeInterval { get set }
    /// 插件
    var plugins: [PluginType] { get set }
    /// 请求头
    var headers: [String: String] { get set }
    
}

extension NetworkConfig {
    var timeoutInterval: TimeInterval {
        get {
            return 30
        }
        set {}
    }
    
    var plugins: [PluginType] {
        get {
            return [RequestLogPlugin(), networkActivityPlugin]
        }
        set {}
    }
    
    var headers: [String: String] {
        get {
            return [:]
        }
        set {}
    }
    
}

struct SWNetworkConfig: NetworkConfig {
    static let config = SWNetworkConfig()
}

class Network: NetworkProtocol {
    static let provider = MoyaProvider<SWTargetType>(config: SWNetworkConfig.config)
}

extension MoyaProvider {
    convenience init(config: NetworkConfig) {
        let requestClosure = { (endpoint: Endpoint,
            done: @escaping MoyaProvider<SWTargetType>.RequestResultClosure) in
            do {
                var request = try endpoint.urlRequest()
                /// 设置请求超时时间
                request.timeoutInterval = config.timeoutInterval
                done(.success(request))
            } catch {
                done(.failure(MoyaError.underlying(error, nil)))
            }
        }
        
        let endpointClosure = { (target :Target) -> Endpoint in
            guard let value = target as? SWTargetType,
                let headers = value.headers,
                headers.keys.count > 0 else {
                    return MoyaProvider.defaultEndpointMapping(for: target)
                    .adding(newHTTPHeaderFields: config.headers)
            }
            // 如果自定义Header, 则使用自定义Header
            return MoyaProvider.defaultEndpointMapping(for: target)
                           .adding(newHTTPHeaderFields: headers)
        }
        self.init(
            endpointClosure: endpointClosure,
            requestClosure: requestClosure,
            plugins: config.plugins
        )
    }
}

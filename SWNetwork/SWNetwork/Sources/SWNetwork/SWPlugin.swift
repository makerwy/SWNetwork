//
//  SWPlugin.swift
//  SWNetwork
//
//  Created by wangyang on 2020/12/31.
//

import Foundation
import Moya
import Result

let networkActivityPlugin = NetworkActivityPlugin { (change, _) in
    switch(change) {
    case .ended:
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    case .began:
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
    }
}

public class RequestLogPlugin: PluginType {
    public func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        guard let target = target as? SWTargetType else { return request }
        if target.showLoading {
            DispatchQueue.main.async {
                //显示hud
            }
        }
        return request
    }
    public func willSend(_ request: RequestType, target: TargetType) {
        guard let target = target as? SWTargetType else { return }
        if target.logEnable {
            let netRequest = request.request
            if let url = netRequest?.description {
                debugPrint("✅✅✅" + url)
            }
            if let httpMethod = netRequest?.httpMethod {
                debugPrint("✅✅✅ Method: \(httpMethod)")
            }
            if let body = netRequest?.httpBody,
               let output = String(data: body, encoding: .utf8) {
                debugPrint("✅✅✅ Body:\(output)")
            }
            if let header = netRequest?.allHTTPHeaderFields {
                debugPrint("✅✅✅ Header:\(header)")
            }
        }
    }
    public func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        guard let target = target as? SWTargetType else { return }
        if target.showLoading {
            DispatchQueue.main.async {
                //取消hud
            }
        }
        if !target.logEnable {
            return
        }
        switch result {
        case .success(let response):
            let request_url = target.baseURL.appendingPathComponent(target.path)
            debugPrint("😘😘😘 \(request_url)")
            if let data = try? response.mapString() {
                debugPrint("😘😘😘 Return Response:")
                debugPrint("😘😘😘 \(data)")
                debugPrint("😘😘😘")
            } else {
                debugPrint("❌❌❌ Can not formatter data")
                debugPrint("❌❌❌")
            }
        case .failure(let error):
            debugPrint("❌❌❌ \(error.errorDescription ?? "没有错误描述")")
        }
    }
}

//
//  SWRequestConfig.swift
//  SWNetwork
//
//  Created by wangyang on 2020/12/30.
//

import Foundation

enum SWHttpMethod : String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

enum SWEncodingType {
    case URL
    case JSON
}

struct SWRequestConfig {
    var baseURL: String = ""
    
    var path: String = ""
    
    var method: SWHttpMethod = .get
    
    var encodingType: SWEncodingType = .URL
    
    var headers: [String : String]?
    
    var params: [String : Any]?
    
    var showLoding: Bool = false
    
    var sampleData: Data = "{}".data(using: String.Encoding.utf8)!
    
    var logEnable: Bool = false
    
}

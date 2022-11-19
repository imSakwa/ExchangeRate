//
//  ExchangeRateTarget.swift
//  ExchangeRate
//
//  Created by ChangMin on 2022/11/19.
//

import Alamofire

enum ExchangeRateTarget {
    case getExchangeRate(ExchangeRequest)
}

extension ExchangeRateTarget: TargetType {
    
    var baseURL: String {
        return "https://www.koreaexim.go.kr"
    }
    
    var method: HTTPMethod {
        switch self {
        case .getExchangeRate: return .get
        }
    }
    
    var path: String {
        switch self {
        case .getExchangeRate: return "/site/program/financial/exchangeJSON/"
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .getExchangeRate(let request): return .query(request)
        }
    }
}

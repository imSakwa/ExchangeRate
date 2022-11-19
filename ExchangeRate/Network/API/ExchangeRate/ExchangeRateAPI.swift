//
//  ExchangeRateAPI.swift
//  ExchangeRate
//
//  Created by ChangMin on 2022/11/19.
//

import Foundation

import Alamofire

struct ExchangeRateAPI {
    /// 금일 환율 정보 가져오기
    static func getExchageRate(
        request: ExchangeRequest,
        completion: @escaping (_ success: [ExchangeResponse]?,  _ failed: Error?) -> Void)
    {
        AF.request(ExchangeRateTarget.getExchangeRate(request))
            .responseDecodable { (response: AFDataResponse<[ExchangeResponse]>) in
                switch response.result {
                case .success(let response):
                    completion(response, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
    
}

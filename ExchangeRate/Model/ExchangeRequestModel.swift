//
//  ExchangeRequestModel.swift
//  ExchangeRate
//
//  Created by ChangMin on 2022/11/18.
//

import Foundation

struct ExchangeRequestModel: Codable {
    let authkey: String
    let searchdate: String? // 기본값 현재일
    let data: String // AP01: 환율, AP02: 대출금리, AP03: 국제금리
    
    init(authkey: String, searchdate: String? = nil, data: String = "AP01") {
        self.authkey = authkey
        self.searchdate = searchdate
        self.data = data
    }
    
}

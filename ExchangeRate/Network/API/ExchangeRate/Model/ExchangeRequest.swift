//
//  ExchangeRequest.swift
//  ExchangeRate
//
//  Created by ChangMin on 2022/11/18.
//

import Foundation

struct ExchangeRequest: Encodable {
    var url: String { "https://www.koreaexim.go.kr/site/program/financial/exchangeJSON" }

    let authkey: String = "HS0cH74Z9qyucKgKjGs3jW5yc9VsKSxd"
    let searchdate: String? // 기본값 현재일
    let data: String // AP01: 환율, AP02: 대출금리, AP03: 국제금리
    
    init(searchdate: String? = nil, data: String = "AP01") {
        self.searchdate = searchdate
        self.data = data
    }
}

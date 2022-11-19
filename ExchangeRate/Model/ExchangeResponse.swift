//
//  ExchangeResponse.swift
//  ExchangeRate
//
//  Created by ChangMin on 2022/11/18.
//

import Foundation

struct ExchangeResponse: Decodable {
    let result: Int
    let currencyName: String
    let currencyUnit: String
    let transferBuying: String
    let transferSelling: String
    let dealBase: String
    let bookPrice: String
    let yearExchangeRate: String
    let tenDayExchangeRate: String

    enum CodingKeys: String, CodingKey {
        case result
        case currencyName = "cur_nm"
        case currencyUnit = "cur_unit"
        case transferBuying = "ttb"
        case transferSelling = "tts"
        case dealBase = "deal_bas_r"
        case bookPrice = "bkpr"
        case yearExchangeRate = "yy_efee_r"
        case tenDayExchangeRate = "ten_dd_efee_r"
    }
}

//
//  MainViewModel.swift
//  ExchangeRate
//
//  Created by ChangMin on 2022/11/19.
//

import Foundation

import RxSwift

final class MainViewModel {
    var exchageRateList = BehaviorSubject<[ExchangeRate]>(value: [])
    var exchageRateArr = [ExchangeRate]()
    
    
    init() {
        fetchData()
    }
    
    func fetchData() {
        let request = ExchangeRequest(searchdate: "20221118")
        ExchangeRateAPI.getExchageRate(request: request) { [weak self] sucess, failed in
            if let failed = failed {
                print(failed.localizedDescription)
                return
            }
            
            if let sucess = sucess {
                sucess.forEach { [weak self] exchageRate in
                    self?.exchageRateArr.append(exchageRate.toDomain)
                }
                self?.exchageRateArr.sort { $0.name < $1.name }
                self?.exchageRateList.onNext(self!.exchageRateArr)
            }
        }
    }
}

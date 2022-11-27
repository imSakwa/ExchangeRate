//
//  MainViewModel.swift
//  ExchangeRate
//
//  Created by ChangMin on 2022/11/19.
//

import Foundation

import RxRelay
import RxSwift

final class MainViewModel {
    var disposeBag = DisposeBag()
    var exchageRateList = BehaviorSubject<[ExchangeRate]>(value: [])
    var exchageRateArr = [ExchangeRate]()
    
    private let convertValue = BehaviorRelay(value: "1")
    
    struct Input {
        let formerNumberText: Observable<String>
        let convertingUnit: Observable<[ExchangeRate]>
    }
    
    struct Output {
        let convertedValue: Observable<String>
    }

    
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
    
    func transform(input: Input) -> Output {
        // TODO: - 해당 국가 환율로 곱해주기
        input.formerNumberText
            .subscribe(onNext: { [weak self] in
                let value = Int($0) ?? 0
                let convert = String(value*2)
                self?.convertValue.accept(convert)
            })
            .disposed(by: disposeBag)
        
        input.convertingUnit
            .subscribe(onNext:  { models in
                print(models[0].name)
            })
            .disposed(by: disposeBag)
        
        
        return Output(
            convertedValue: convertValue.asObservable()
        )
    }
}

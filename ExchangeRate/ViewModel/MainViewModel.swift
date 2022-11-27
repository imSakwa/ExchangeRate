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
        let formerUnit: Observable<[ExchangeRate]>
        let afterUnit: Observable<[ExchangeRate]>
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
        // 다른 나라 -> 원화
        Observable.combineLatest(input.formerNumberText, input.formerUnit)
            .subscribe(onNext: { [weak self] number, model in
                let value = Double(number) ?? 0.0
                let formatter = NumberFormatter()
                formatter.numberStyle = .decimal
                let selling = formatter.number(from: model[0].selling) as! Double
                
                let convert = String(round((value*selling)*100)/100)
                self?.convertValue.accept(convert)
            })
            .disposed(by: disposeBag)
        
        // 원화 -> 다른 나라
        Observable.combineLatest(input.formerNumberText, input.afterUnit)
            .subscribe(onNext: { [weak self] number, model in
                let value = Double(number) ?? 0.0
                let formatter = NumberFormatter()
                formatter.numberStyle = .decimal
                let buying = formatter.number(from: model[0].buying) as! Double
                
                let convert = String(round(value/buying*100)/100)
                self?.convertValue.accept(convert)
            })
            .disposed(by: disposeBag)
        
        return Output(
            convertedValue: convertValue.asObservable()
        )
    }
}

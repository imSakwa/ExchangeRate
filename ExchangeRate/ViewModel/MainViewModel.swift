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
    
    private let convertValue = PublishRelay<String>()
    
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
        var currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        
        if Calendar.current.isDateInWeekend(currentDate) {
            let todayWeekDay = Calendar.current.dateComponents([.weekday], from: currentDate).weekday
            if todayWeekDay == 1 { // 일요일
                currentDate = Calendar.current.date(byAdding: .day, value: -2, to: currentDate)!
            }
            
            if todayWeekDay == 7 { // 토요일
                currentDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate)!
            }
        }
        
        let searchData = dateFormatter.string(from: currentDate)
        let request = ExchangeRequest(searchdate: searchData)
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

//
//  ViewController.swift
//  ExchangeRate
//
//  Created by ChangMin on 2022/11/18.
//

import UIKit

import RxSwift
import SnapKit

final class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let request = ExchangeRequest(searchdate: "20221118")
        ExchangeRateAPI.getExchageRate(request: request) { sucess, failed in
            print(sucess, failed)
        }
    }


}


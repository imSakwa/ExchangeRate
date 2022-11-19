//
//  MainViewController.swift
//  ExchangeRate
//
//  Created by ChangMin on 2022/11/18.
//

import UIKit

import SnapKit

final class MainViewController: UIViewController {
    
    private lazy var formerUnitBox: ConvertBoxView = {
        let boxView = ConvertBoxView()
        return boxView
    }()
    
    private lazy var afterUnitBox: ConvertBoxView = {
        let boxView = ConvertBoxView()
        return boxView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        view.subviews.forEach { subView in
            subView.layoutSubviews()
        }
    }
}

private extension MainViewController {
    
    func setupLayout() {
        [formerUnitBox, afterUnitBox].forEach { view.addSubview($0) }
        
        formerUnitBox.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(120)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().inset(12)
            $0.height.equalTo(40)
        }
        
        afterUnitBox.snp.makeConstraints {
            $0.top.equalTo(formerUnitBox.snp.bottom).offset(60)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(formerUnitBox)
        }
    }
    
    func setupView() {
        view.backgroundColor = .white
    }
}

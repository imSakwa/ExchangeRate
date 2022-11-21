//
//  MainViewController.swift
//  ExchangeRate
//
//  Created by ChangMin on 2022/11/18.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class MainViewController: UIViewController {
    private let viewModel = MainViewModel()
    private let disposebag = DisposeBag()
    
    private lazy var formerUnitBox: ConvertBoxView = {
        let boxView = ConvertBoxView()
        return boxView
    }()
    
    private lazy var convertButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "arrow.up.arrow.down")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = .black.withAlphaComponent(0.5)
        return button
    }()
    
    private lazy var afterUnitBox: ConvertBoxView = {
        let boxView = ConvertBoxView()
        return boxView
    }()
    
    private lazy var explainTextView: UITextView = {
        let textView = UITextView()
        textView.text =
        """
        1 미국 달러 = \n1300 대한민국 원
        """
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupView()
        bindView()
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
        [formerUnitBox, convertButton, afterUnitBox, explainTextView].forEach { view.addSubview($0) }
                
        formerUnitBox.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(240)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().inset(12)
            $0.height.equalTo(40)
        }
        
        convertButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(formerUnitBox.snp.bottom).offset(18)
            $0.size.equalTo(24)
        }
        
        afterUnitBox.snp.makeConstraints {
            $0.top.equalTo(formerUnitBox.snp.bottom).offset(60)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(formerUnitBox)
        }
        
        explainTextView.snp.makeConstraints {
            $0.top.equalTo(afterUnitBox.snp.bottom).offset(24)
            $0.leading.trailing.equalTo(formerUnitBox)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-120)
        }
    }
    
    func setupView() {
        view.backgroundColor = .white
        print("finish")
    }
    
    func bindView() {
        formerUnitBox.countryPickerView.rx
            .itemAttributedTitles(<#T##source: ObservableType##ObservableType#>)
        
        viewModel.exchageRateList
            .bind(to: formerUnitBox.countryPickerView.rx.itemTitles) { _, item in
                return item.name
            }
            .disposed(by: disposebag)
                
    }
}

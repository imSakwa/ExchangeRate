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
    
    private var formerUnitText: String = ""
    private var afterUnitText: String = ""
    
    private lazy var formerUnitBox: ConvertBoxView = {
        let boxView = ConvertBoxView()
        boxView.countryPickTextField.text = "미국 달러"
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
        boxView.numberTextField.isEnabled = false
        boxView.countryPickTextField.text = "한국 원"
        return boxView
    }()
    
    private lazy var explainTextView: UITextView = {
        let textView = UITextView()
//        textView.text =
//        """
//        1 미국 달러 = \n1300 대한민국 원
//        """
        return textView
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindView()
        
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
        [formerUnitBox, convertButton, afterUnitBox, explainTextView].forEach { view.addSubview($0) }
                
        formerUnitBox.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(240)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().inset(12)
            $0.height.equalTo(44)
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
    }
    
    func bindView() {
        let formerPickerView = formerUnitBox.countryPickTextField.inputView as! UIPickerView
        let afterPickerView = afterUnitBox.countryPickTextField.inputView as! UIPickerView
        
        viewModel.exchageRateList
            .bind(to: formerPickerView.rx.items) { _, item, _ in
                let pickerLabel = UILabel()
                pickerLabel.text = item.name
                pickerLabel.font = .boldSystemFont(ofSize: 15)
                pickerLabel.textAlignment = .center
                return pickerLabel
            }
            .disposed(by: disposebag)
        
        viewModel.exchageRateList
            .bind(to: afterPickerView.rx.items) { _, item, _ in
                let pickerLabel = UILabel()
                pickerLabel.text = item.name
                pickerLabel.font = .boldSystemFont(ofSize: 15)
                pickerLabel.textAlignment = .center
                return pickerLabel
            }
            .disposed(by: disposebag)
        
        formerPickerView.rx.modelSelected(ExchangeRate.self)
            .subscribe(onNext: { [weak self] value in
                self?.formerUnitBox.countryPickTextField.text = value[0].name
                self?.afterUnitBox.countryPickTextField.text = "한국 원"
                afterPickerView.selectRow(20, inComponent: 0, animated: true)
            })
            .disposed(by: disposebag)
        
        afterPickerView.rx.modelSelected(ExchangeRate.self)
            .subscribe(onNext: { [weak self] value in
                self?.afterUnitBox.countryPickTextField.text = value[0].name
                self?.formerUnitBox.countryPickTextField.text = "한국 원"
                formerPickerView.selectRow(20, inComponent: 0, animated: true)
            })
            .disposed(by: disposebag)
        
        let input = MainViewModel.Input(
            formerNumberText: formerUnitBox.numberTextField.rx.text.orEmpty.asObservable(),
            formerUnit: formerPickerView.rx.modelSelected(ExchangeRate.self).asObservable(),
            afterUnit: afterPickerView.rx.modelSelected(ExchangeRate.self).asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.convertedValue
            .map { $0 == "0.0" ? "" : $0 }
            .bind(to: afterUnitBox.numberTextField.rx.text)
            .disposed(by: disposebag)
    }
}

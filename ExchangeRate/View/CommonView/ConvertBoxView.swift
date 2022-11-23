//
//  ConvertBoxView.swift
//  ExchangeRate
//
//  Created by ChangMin on 2022/11/19.
//

import UIKit

import SnapKit

final class ConvertBoxView: UIView {
    
    private lazy var numberTextField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .numberPad
        textField.textAlignment = .center
        return textField
    }()
    
    private lazy var dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = 0.5
        return view
    }()
    
    lazy var countryPickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.selectRow(3, inComponent: 0, animated: true)
        picker.subviews.first?.subviews.last?.backgroundColor = UIColor.red
        return picker
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.masksToBounds = true
        layer.cornerRadius = frame.height / 4
        layer.borderColor = UIColor.black.withAlphaComponent(0.5).cgColor
        layer.borderWidth = 1
    }
    
    required init?(coder: NSCoder) { fatalError() }
}

private extension ConvertBoxView {
    
    /// 뷰 레이아웃
    func setupLayout() {
        [numberTextField, dividerView, countryPickerView].forEach { addSubview($0) }
        
        numberTextField.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().inset(4)
            $0.width.equalToSuperview().dividedBy(2)
        }
        
        dividerView.snp.makeConstraints {
            $0.leading.equalTo(numberTextField.snp.trailing).offset(1)
            $0.width.equalTo(1)
            $0.top.bottom.equalToSuperview().inset(8)
        }
        
        countryPickerView.snp.makeConstraints {
            $0.leading.equalTo(dividerView.snp.trailing).offset(1)
            $0.top.bottom.equalToSuperview()
            $0.trailing.equalToSuperview().inset(4)
        }
    }
    
    func setupView() {
        
    }
}

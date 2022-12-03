//
//  ConvertBoxView.swift
//  ExchangeRate
//
//  Created by ChangMin on 2022/11/19.
//

import UIKit

import SnapKit

final class ConvertBoxView: UIView {
    
    lazy var numberTextField: UITextField = {
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
    
    lazy var countryPickTextField: UITextField = {
        let textfield = UITextField()
        textfield.delegate = self
        textfield.tintColor = .clear
        textfield.textAlignment = .center
        return textfield
    }()
    
    lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        return pickerView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
        setupView()
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
        [numberTextField, dividerView, countryPickTextField].forEach { addSubview($0) }
        
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
        
        countryPickTextField.snp.makeConstraints {
            $0.leading.equalTo(dividerView.snp.trailing).offset(1)
            $0.top.bottom.equalToSuperview()
            $0.trailing.equalToSuperview().inset(4)
        }
    }
    
    func setupView() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(clickDone))
   
        toolBar.setItems([space , doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
            
        countryPickTextField.inputView = pickerView
        countryPickTextField.inputAccessoryView = toolBar
    }
    
    @objc func clickDone() {
        countryPickTextField.endEditing(true)
    }
}

extension ConvertBoxView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}

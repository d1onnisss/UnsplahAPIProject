//
//  SignInController.swift
//  Geeks
//
//  Created by Alexey Lim on 14/8/24.
//

import UIKit
import SnapKit

class SignInController: UIViewController {
    
    private lazy var welcomeLabel: UILabel = {
        let view = UILabel()
        view.text = "Welcome! Please Sign In"
        view.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        view.textColor = .black
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.spacing = 10
        return view
    }()
    
    private lazy var firstnameTF: UITextField = {
        let tf = UITextField()
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.black.cgColor
        tf.layer.cornerRadius = 12
        tf.textColor = .black
        
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.darkGray
        ]
        tf.attributedPlaceholder = NSAttributedString(string: "Enter your first name", attributes: placeholderAttributes)
        
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        tf.leftView = leftView
        tf.leftViewMode = .always
        tf.addTarget(self, action: #selector(textFieldsChanged), for: .editingChanged)
        tf.addTarget(self, action: #selector(textFieldsValidate), for: .editingChanged)
        
        return tf
    }()
    
    private lazy var lastnameTF: UITextField = {
        let tf = UITextField()
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.black.cgColor
        tf.layer.cornerRadius = 12
        tf.textColor = .black
        
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.darkGray
        ]
        tf.attributedPlaceholder = NSAttributedString(string: "Enter your last name", attributes: placeholderAttributes)
        
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        tf.leftView = leftView
        tf.leftViewMode = .always
        tf.addTarget(self, action: #selector(textFieldsChanged), for: .editingChanged)
        tf.addTarget(self, action: #selector(textFieldsValidate), for: .editingChanged)
        
        return tf
    }()
    
    private lazy var emailTF: UITextField = {
        let tf = UITextField()
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.black.cgColor
        tf.layer.cornerRadius = 12
        tf.textColor = .black
        
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.darkGray
        ]
        tf.attributedPlaceholder = NSAttributedString(string: "Enter your email", attributes: placeholderAttributes)
        
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        tf.leftView = leftView
        tf.leftViewMode = .always
        tf.addTarget(self, action: #selector(textFieldsChanged), for: .editingChanged)
        tf.addTarget(self, action: #selector(textFieldsValidate), for: .editingChanged)
        
        return tf
    }()
    
    private lazy var passwordTF: UITextField = {
        let tf = UITextField()
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.black.cgColor
        tf.layer.cornerRadius = 12
        tf.textColor = .black
        
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.darkGray
        ]
        tf.attributedPlaceholder = NSAttributedString(string: "Enter your password", attributes: placeholderAttributes)
        
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        tf.leftView = leftView
        tf.leftViewMode = .always
        
        let rightButton = UIButton(type: .custom)
        rightButton.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        rightButton.tintColor = .darkGray
        rightButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 50))
        paddingView.addSubview(rightButton)
        rightButton.frame = CGRect(x: 0, y: 0, width: 40, height: 20)
        rightButton.center = paddingView.center
        
        tf.rightView = paddingView
        tf.rightViewMode = .always
        
        tf.addTarget(self, action: #selector(textFieldsChanged), for: .editingChanged)
        tf.addTarget(self, action: #selector(textFieldsValidate), for: .editingChanged)
        
        return tf
    }()

    private let enterBtn: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemGray4
        button.layer.cornerRadius = 16
        button.setTitle("Enter", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.isEnabled = false
        button.addTarget(self, action: #selector(enterBtnTapped), for: .touchUpInside)
        return button
    }()
    
    private let alreadyHaveAccBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Already Have An Account?", for: .normal)
        button.setTitleColor(.systemGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        button.addTarget(self, action: #selector(alreadyHaveAccBtnTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    @objc private func textFieldsChanged() {
        enterBtn.isEnabled = !(firstnameTF.text?.isEmpty ?? true) &&
        !(lastnameTF.text?.isEmpty ?? true) &&
        !(emailTF.text?.isEmpty ?? true) &&
        !(passwordTF.text?.isEmpty ?? true)
    }
    
    @objc private func textFieldsValidate() {
        if !(firstnameTF.text?.isEmpty ?? true) &&
            !(lastnameTF.text?.isEmpty ?? true) &&
            !(emailTF.text?.isEmpty ?? true) &&
            !(passwordTF.text?.isEmpty ?? true) {
            enterBtn.backgroundColor = .systemRed
        } else {
            enterBtn.backgroundColor = .systemGray4
        }
    }
    
    @objc private func enterBtnTapped() {
        guard let firstName = firstnameTF.text, !firstName.isEmpty,
              let lastName = lastnameTF.text, !lastName.isEmpty,
              let email = emailTF.text, !email.isEmpty,
              let password = passwordTF.text, !password.isEmpty else {return}
        
        NetworkManager.shared.register(firstName: firstName, lastName: lastName, email: email, password: password)
        
        let vc = LoginController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func togglePasswordVisibility() {
        passwordTF.isSecureTextEntry.toggle()
        let imageName = passwordTF.isSecureTextEntry ? "eye.slash.fill" : "eye.fill"
        if let rightButton = passwordTF.rightView?.subviews.first as? UIButton {
            rightButton.setImage(UIImage(systemName: imageName), for: .normal)
        }
    }
    
    @objc func alreadyHaveAccBtnTapped() {
        let vc = LoginController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setupUI() {
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(50)
            make.centerY.equalToSuperview()
        }
        
        view.addSubview(welcomeLabel)
        welcomeLabel.snp.makeConstraints { make in
            make.bottom.equalTo(stackView.snp.top).offset(-10)
            make.centerX.equalToSuperview()
        }
        
        stackView.addArrangedSubview(firstnameTF)
        stackView.addArrangedSubview(lastnameTF)
        stackView.addArrangedSubview(emailTF)
        stackView.addArrangedSubview(passwordTF)
        
        firstnameTF.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        lastnameTF.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        emailTF.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        passwordTF.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        view.addSubview(alreadyHaveAccBtn)
        alreadyHaveAccBtn.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(50)
        }
        
        view.addSubview(enterBtn)
        enterBtn.snp.makeConstraints { make in
            make.top.equalTo(alreadyHaveAccBtn.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(50)
            make.height.equalTo(50)
        }
    }
}

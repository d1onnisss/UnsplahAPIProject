//
//  LoginController.swift
//  Geeks
//
//  Created by Alexey Lim on 14/8/24.
//

import UIKit
import FirebaseFirestore

class LoginController: UIViewController {
    
    private lazy var db = Firestore.firestore()
    
    private lazy var welcomeLabel: UILabel = {
        let view = UILabel()
        view.text = "Welcome back! Please Login"
        view.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .black
        setupUI()
    }
    
    func didLoginFail() {
        emailTF.layer.borderColor = UIColor.red.cgColor
        passwordTF.layer.borderColor = UIColor.red.cgColor
    }
    
    @objc private func textFieldsChanged() {
        enterBtn.isEnabled = !(emailTF.text?.isEmpty ?? true) &&
        !(passwordTF.text?.isEmpty ?? true)
    }
    
    @objc private func textFieldsValidate() {
        if !(emailTF.text?.isEmpty ?? true) &&  !(passwordTF.text?.isEmpty ?? true) {
            enterBtn.backgroundColor = .systemRed
        } else {
            enterBtn.backgroundColor = .systemGray4
        }
    }
    
    private func resetBorderColors() {
        emailTF.layer.borderColor = UIColor.black.cgColor
        passwordTF.layer.borderColor = UIColor.black.cgColor
    }
    
    @objc private func togglePasswordVisibility() {
        passwordTF.isSecureTextEntry.toggle()
        let imageName = passwordTF.isSecureTextEntry ? "eye.slash.fill" : "eye.fill"
        if let rightButton = passwordTF.rightView?.subviews.first as? UIButton {
            rightButton.setImage(UIImage(systemName: imageName), for: .normal)
        }
    }
    
    @objc private func enterBtnTapped() {
        guard let email = emailTF.text, let password = passwordTF.text else { return }
        
        db.collection("users").whereField("email", isEqualTo: email).getDocuments { [weak self] (querySnapshot, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Error getting documents: \(error)")
                self.didLoginFail()
                return
            }
            
            if let documents = querySnapshot?.documents, !documents.isEmpty {
                let userData = documents[0].data()
                
                if let dbPassword = userData["password"] as? String, dbPassword == password {
                    let vc = TabBarController()
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    self.didLoginFail()
                }
            } else {
                self.didLoginFail()
            }
        }
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
        
        stackView.addArrangedSubview(emailTF)
        stackView.addArrangedSubview(passwordTF)
        stackView.addArrangedSubview(enterBtn)
        
        emailTF.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        passwordTF.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        enterBtn.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
    }
}

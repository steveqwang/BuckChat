//
//  HandlerLoginVC.swift
//  BuckChat
//
//  Created by Yu Wang on 2018-02-07.
//

import UIKit

protocol sendDataToLoginVCDelegate {
    func sendData(email: String, password: String)
}

class SignupVC: UIViewController, UITextFieldDelegate {
    
    var delegate: sendDataToLoginVCDelegate? = nil
    
    var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "default_profile")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = UIColor.white
        tf.placeholder = " NickName:"
        tf.layer.cornerRadius = 10
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = UIColor.white
        tf.placeholder = " Email:"
        tf.layer.cornerRadius = 10
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = UIColor.white
        tf.placeholder = " Password:"
        tf.layer.cornerRadius = 10
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let selectImageButton: UIButton = {
        let button = UIButton(type: UIButtonType.roundedRect)
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor(red: 60/255, green: 101/255, blue: 181/255, alpha: 1)
        button.setTitle("Click to select Profile Image(optional)", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        
        button.addTarget(self, action: #selector(handleSelectProfileImageView), for: .touchUpInside)
        
        return button
    }()
    
    let finishSignupButton: UIButton = {
        let button = UIButton(type: UIButtonType.roundedRect)
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor(red: 70/255, green: 111/255, blue: 171/255, alpha: 1)
        button.setTitle("Sign Up", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        
        button.addTarget(self, action: #selector(finishSignupAndUploadData), for: .touchUpInside)
        
        return button
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton(type: UIButtonType.roundedRect)
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor(red: 70/255, green: 111/255, blue: 171/255, alpha: 1)
        button.setTitle("Cancel", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        
        button.addTarget(self, action: #selector(cancelSignup), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 53/255, green: 126/255, blue: 199/255, alpha: 1)
        view.isUserInteractionEnabled = true
        //view.addGestureRecognizer(tapGestureRecognizer)
        
        view.addSubview(profileImageView)
        view.addSubview(nameTextField)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(selectImageButton)
        view.addSubview(finishSignupButton)
        view.addSubview(cancelButton)
        
        setupProfileImageView()
        setupInputTextFields()
        setupSelectImageButton()
        setupFinishSignupButton()
        setupCancelButton()
    }
    
    func setupProfileImageView() {
        //need x, y, width, height constraints
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: nameTextField.topAnchor, constant: -20).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    func setupInputTextFields() {
        emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        emailTextField.delegate = self
        
        nameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameTextField.bottomAnchor.constraint(equalTo: emailTextField.topAnchor, constant: -15).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        nameTextField.delegate = self
        
        passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 15).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        passwordTextField.delegate = self
    }
    
    func setupSelectImageButton() {
        selectImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        selectImageButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 15).isActive = true
        selectImageButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40).isActive = true
        selectImageButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func setupFinishSignupButton() {
        finishSignupButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        finishSignupButton.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -20).isActive = true
        finishSignupButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40).isActive = true
        finishSignupButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func setupCancelButton() {
        cancelButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cancelButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        cancelButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
}

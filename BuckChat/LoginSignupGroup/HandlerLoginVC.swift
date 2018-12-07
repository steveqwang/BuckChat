//
//  HandlerLoginVC.swift
//  BuckChat
//
//  Created by Yu Wang on 2018-02-07.
//

import UIKit
import Firebase

extension LoginVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate, sendDataToLoginVCDelegate {
    
    // method for sendDataToLoginVCDelegate protocol
    func sendData(email: String, password: String) {
        emailTextField.text = email
        passwordTextField.text = password
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func showSignupVC() {
        let signupVC = SignupVC()
        signupVC.delegate = self // for sendDataToLoginVCDelegate protocol
        present(signupVC, animated: true, completion: nil)
    }
    
    @objc func loginButtonPressed() {
        guard emailTextField.text != "", passwordTextField.text != "" else {
            let alert = AlertCenter.alertPlain(title: "Invalid Form", message: "Please complete the login form")
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        activityIndicator.startAnimating()
        
        let email = emailTextField.text!, password = passwordTextField.text!
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { [weak self] (user, error) in
            
            if let error = error {
                self?.activityIndicator.stopAnimating()
                switch error.localizedDescription {
                case "The email address is badly formatted.":
                    let alert = AlertCenter.alertPlain(title: "Wrong Email Format", message: "Not an email address.")
                    self?.present(alert, animated: true, completion: nil)
                case "There is no user record corresponding to this identifier. The user may have been deleted.":
                    let alert = AlertCenter.alertPlain(title: "Invalid User", message: "User email not registered yet, please sign up first")
                    self?.present(alert, animated: true, completion: nil)
                case "The password is invalid or the user does not have a password.":
                    let alert = AlertCenter.alertPlain(title: "Wrong Password", message: "The password is Wrong")
                    self?.present(alert, animated: true, completion: nil)
                default:
                    print("No error upon signing in")
                }
                //print(error.localizedDescription) // this is for debugging and adding more error-handling switch cases
                return
            }
            
            //CurrentUserInfo.setValuesWithCurrentUser()
            //CurrentUserInfo.loadFriends()
            print(CurrentUserInfo.friends.count)
            //successfully logged in our user
            let newTabBarVC = TabBarVC()
            
            self?.present(newTabBarVC, animated: true, completion: nil)
        })
        
    }
    
}


//
//  HandlerLoginVC.swift
//  BuckChat
//
//  Created by Yu Wang on 2018-02-07.
//


import UIKit
import Firebase

extension SignupVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func cancelSignup() {
        dismiss(animated: true, completion: nil)
    }
    
    // on tap dismiss the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func handleSelectProfileImageView() {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            profileImageView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func finishSignupAndUploadData() {
        guard nameTextField.text != "", emailTextField.text != "", passwordTextField.text != "" else {
            let alert = AlertCenter.alertPlain(title: "Missing Fields", message: "Please complete your profile!")
            present(alert, animated: true, completion: nil)
            return
        }
        
        let name = nameTextField.text!, email = emailTextField.text!, password = passwordTextField.text!
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { [weak self] (user: User?, error) in
            
            if let error = error {
                if error.localizedDescription == "The password must be 6 characters long or more." {
                    let alert = AlertCenter.alertPlain(title: "Invalid Password", message: "The password must be 6 characters long or more.")
                    self!.present(alert, animated: true, completion: nil)
                }else if error.localizedDescription == "The email address is already in use by another account." {
                    let alert = AlertCenter.alertPlain(title: "Invalid Email Address", message: "The email address is already in use by another account.")
                    self!.present(alert, animated: true, completion: nil)
                }
                return
            }
            
            guard let uid = user?.uid else {
                return
            }
            
            //successfully authenticated user
            let imageName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).jpg")
            
            if let profileImage = self!.profileImageView.image, let uploadData = UIImageJPEGRepresentation(profileImage, 0.1) {
                
                storageRef.putData(uploadData, metadata: nil, completion: { [weak self] (metadata, error) in
                    
                    if let error = error {
                        print(error.localizedDescription)
                        
                        return
                    }
                    
                    if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                        
                        let values = ["name": name, "email": email, "profileImageUrl": profileImageUrl]
                        
                        self!.registerUserIntoDatabaseWithUID(uid, values: values as [String : AnyObject])
                    }
                })
            }
        })
    }
    
    fileprivate func registerUserIntoDatabaseWithUID(_ uid: String, values: [String: AnyObject]) {
        let ref = Database.database().reference()
        let usersReference = ref.child("users").child(uid)
        
        usersReference.updateChildValues(values, withCompletionBlock: { [weak self] (err, ref) in
            
            if let err = err {
                print(err.localizedDescription)
                return
            }
            
            // FriendshipStatus
            // 0 means is friend,
            // 1 means friend request sent but on pending
            // 2 means friend request received but on pending
            let ref = Database.database().reference().child("friendships").child(uid).child("chatbot")
            
            let friendValuesChatbot: [String : String] = ["name": "chatbot", "email": "chat@hotmail.com", "profileImageUrl": "https://firebasestorage.googleapis.com/v0/b/chatchat-c2290.appspot.com/o/profile_images%2F1FA6AA25-0EAD-46E6-8199-949E524669AD.jpg?alt=media&token=7133b721-d628-40da-8458-9e16bee26774", "friendshipStatus" : "isFriend"]
            ref.updateChildValues(friendValuesChatbot) { (err, ref) in
                if let err = err {
                    print(err.localizedDescription)
                    return
                }
                
                // fire protocol method sendDataToLoginVCDelegate
                if self?.delegate != nil {
                    self!.delegate!.sendData(email: self!.emailTextField.text!, password: self!.passwordTextField.text!)
                }
                
                self?.dismiss(animated: true, completion: nil)

            }
        })
    }
    
}

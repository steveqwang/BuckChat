import UIKit
import Firebase

class AlertCenter {
    
    class func alertPlain(title: String?, message: String?) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: {(_) -> Void in alert.dismiss(animated: true, completion: nil)})
        alert.addAction(action)
        
        return alert
    }
    
    class func alertSendFriendRequest(title: String, message: String, targetAppUser: AppUser, searchVC: SearchForContactsVC, selectedIndex: Int) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            if let uid = targetAppUser.id {
                let ref = Database.database().reference().child("friendships").child(Auth.auth().currentUser!.uid).child(uid)
                if let name = targetAppUser.name, let email = targetAppUser.email, let profileImageUrl = targetAppUser.profileImageUrl{
                    
                    let pendingValues: [String : String] = ["name": name, "email": email, "profileImageUrl": profileImageUrl, "friendshipStatus": "requestSentButOnPending"]
                    
                    ref.updateChildValues(pendingValues, withCompletionBlock: { (err, ref) in
                        if let err = err {
                            print(err.localizedDescription)
                            return
                        }
                        
                        let newRef = Database.database().reference().child("friendships").child(uid).child(Auth.auth().currentUser!.uid)
                        CurrentUserInfo.dictionary!["friendshipStatus"] = "requestReceivedButOnPending"
                        newRef.updateChildValues(CurrentUserInfo.dictionary!, withCompletionBlock: { (err, ref) in
                            if let err = err {
                                print(err.localizedDescription)
                                return
                            }
                            
                            searchVC.searchResults.remove(at: selectedIndex)
                            searchVC.tableView.reloadData()
                            let alert = alertPlain(title: "Sent", message: "Friend request has been sent")
                            
                            searchVC.present(alert, animated: true, completion: nil)
                        })
                    })
                }
                
            }
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel))
        return alert
    }
    
    class func alertAcceptFriendRequest(title: String, message: String, targetAppUser: AppUser, searchVC: SearchForContactsVC, selectedIndex: Int) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            if let uid = targetAppUser.id {
                let ref = Database.database().reference().child("friendships").child(Auth.auth().currentUser!.uid).child(uid)
                    
                ref.updateChildValues(["friendshipStatus": "isFriend"], withCompletionBlock: { (err, ref) in
                        if let err = err {
                            print(err.localizedDescription)
                            return
                        }
                        
                        let newRef = Database.database().reference().child("friendships").child(uid).child(Auth.auth().currentUser!.uid)
                        newRef.updateChildValues(["friendshipStatus": "isFriend"], withCompletionBlock: { (err, ref) in
                            if let err = err {
                                print(err.localizedDescription)
                                return
                            }
                            
                            searchVC.pendingReceivedRequest.remove(at: selectedIndex)
                            searchVC.tableView.reloadData()
                            let alert = alertPlain(title: "Friend Added", message: "You add a friend successfully, you can chat now")
                            
                            targetAppUser.friendshipStatus = "isFriend"
                            CurrentUserInfo.friends.append(targetAppUser)
                            
                            searchVC.present(alert, animated: true, completion: nil)
                        })
                    })
                }
                
            }
        ))
        alert.addAction(UIAlertAction(title: "No", style: .cancel))
        return alert
    }
    
}

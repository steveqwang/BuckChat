//
//  HandlerLoginVC.swift
//  BuckChat
//
//  Created by Yu Wang on 2018-02-07.
//

import Foundation
import Firebase

public class CurrentUserInfo {
    
    static var dictionary: [String: String]?
    
    static var friends = [AppUser]()
    
    class func setValuesWithCurrentUser() {
        let ref = Database.database().reference().child("users").child(Auth.auth().currentUser!.uid)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            dictionary = snapshot.value as? [String: String]
        }, withCancel: nil)
        //ref.queryOrdered(byChild: "name").queryEqual(toValue: searchBar.text!).
    }
    class func loadFriends() {
        let ref = Database.database().reference().child("friendships").child(Auth.auth().currentUser!.uid)
        ref.observe(.childAdded, with: { (DataSnapshot) in
            if let dic = DataSnapshot.value as? [String: AnyObject] {
                let user = AppUser(dictionary: dic)
                user.id = DataSnapshot.key
                //if you use this setter, your app will crash if your class properties don't exactly match up with the firebase dictionary keys
                if user.friendshipStatus == "isFriend"{
                    self.friends.append(user)
                }
            }
        }, withCancel: nil)
    }
    
}

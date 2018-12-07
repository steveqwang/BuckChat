//
//  HandlerLoginVC.swift
//  BuckChat
//
//  Created by Yu Wang on 2018-02-07.
//


import UIKit

class AppUser: NSObject {
    var id: String?
    var name: String?
    var email: String?
    var profileImageUrl: String?
    var friendshipStatus: String?
    init(dictionary: [String: AnyObject]) {
        self.id = dictionary["id"] as? String
        self.name = dictionary["name"] as? String
        self.email = dictionary["email"] as? String
        self.profileImageUrl = dictionary["profileImageUrl"] as? String
        self.friendshipStatus = dictionary["friendshipStatus"] as? String
        
    }
}

//
//  HandlerLoginVC.swift
//  BuckChat
//
//  Created by Yu Wang on 2018-02-07.
//


import UIKit

class TabBarVC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let chatsTVC = ChatsTVC()
        let firstNavController = UINavigationController(rootViewController: chatsTVC)
        firstNavController.title = "Chat"
        firstNavController.tabBarItem.image = UIImage(named: "Tab_Bar_Chats_icon")
        
        let contactsTVC = ContactsTVC()
        let secondNavController = UINavigationController(rootViewController: contactsTVC)
        secondNavController.title = "Contacts"
        secondNavController.tabBarItem.image = UIImage(named: "contacts_icon")
        self.delegate = contactsTVC
        
        let exploreTVC = ExploreTVC()
        let thirdNavController = UINavigationController(rootViewController: exploreTVC)
        thirdNavController.title = "Explore"
        thirdNavController.tabBarItem.image = UIImage(named: "explore_icon")

        let profileTVC = ProfileTVC()
        let fourthNavController = UINavigationController(rootViewController: profileTVC)
        fourthNavController.title = "Me"
        fourthNavController.tabBarItem.image = UIImage(named: "tab_bar_profile")

        viewControllers = [firstNavController, secondNavController, thirdNavController, fourthNavController]
        
        //viewControllers = [firstNavController, secondNavController]
        self.tabBar.items![0].title = "Chat"
        self.tabBar.items![1].title = "Contacts"
        self.tabBar.items![2].title = "Explore"
        self.tabBar.items![3].title = "Profile"
    }
    
}


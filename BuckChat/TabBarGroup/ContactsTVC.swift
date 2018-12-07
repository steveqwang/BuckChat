//
//  HandlerLoginVC.swift
//  BuckChat
//
//  Created by Yu Wang on 2018-02-07.
//

import UIKit
import Firebase

class ContactsTVC: UITableViewController, UITabBarControllerDelegate {
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = UIImage(named: "Add_Contacts")
        
        tableView.register(ResultCell.self, forCellReuseIdentifier: cellId)
        tableView.reloadData()
        
        tableView.separatorStyle = .none
        //navigationItem.title = "Contacts"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(showSearchContactsVC))
    }
    
    @objc func showSearchContactsVC() {
        let searchVC = SearchForContactsVC()
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(CurrentUserInfo.friends.count)
        return CurrentUserInfo.friends.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ResultCell
        
        let friend = CurrentUserInfo.friends[indexPath.row]
        cell.content = friend
        
        if let profileImageUrl = friend.profileImageUrl {
            cell.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let userToBePassed = CurrentUserInfo.friends[indexPath.row]
        let messagesCVC = MessagesCVC(collectionViewLayout: UICollectionViewFlowLayout())
        messagesCVC.user = userToBePassed
        self.navigationController?.pushViewController(messagesCVC, animated: true)
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if self.tabBarController?.selectedIndex == 1{
            print(CurrentUserInfo.friends.count)
            self.tableView.reloadData()
        }
    }
    
}

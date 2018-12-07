//
//  HandlerLoginVC.swift
//  BuckChat
//
//  Created by Yu Wang on 2018-02-07.
//

import UIKit
import Firebase

class SearchForContactsVC: UITableViewController, UISearchBarDelegate {

    let cellID = "cellID"
    var searchResults = [AppUser]()
    var pendingSentRequest = [AppUser]()
    var pendingReceivedRequest = [AppUser]()
    //var friendshipStatus = [String]()
    
    lazy var searchBar:UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = UISearchBarStyle.prominent
        searchBar.placeholder = " Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        
        return searchBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        loadPendingFriendsRequests()
        
//        let tapReconizer = UIGestureRecognizer(target: self, action: #selector(handleHideKeyboard))
//        tapReconizer.cancelsTouchesInView = false
//        tableView.addGestureRecognizer(tapReconizer)
        tableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleHideKeyboard), flag: false))
        
        navigationItem.titleView = searchBar
        
        tableView.register(ResultCell.self, forCellReuseIdentifier: cellID)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        (self.navigationController?.viewControllers[0] as! ContactsTVC).tableView.reloadData()
    }
    
    @objc func handleHideKeyboard() {
        searchBar.endEditing(true)
    }
    
    func loadPendingFriendsRequests() {
        let friendshipStatusQuery = Database.database().reference().child("friendships").child(Auth.auth().currentUser!.uid)
        friendshipStatusQuery.observe(.childAdded, with: { [weak self] (DataSnapshot) in
            
            if let dictionary = DataSnapshot.value as? [String: AnyObject] {
                let user = AppUser(dictionary: dictionary)
                user.id = DataSnapshot.key
                switch user.friendshipStatus {
                case FriendshipStatus.requestSentButOnPending.rawValue?:
                    self?.pendingSentRequest.append(user)
                case FriendshipStatus.requestReceivedButOnPending.rawValue?:
                    self?.pendingReceivedRequest.append(user)
                case FriendshipStatus.isFriend.rawValue?:
                    break
                default:
                    break
                }
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }, withCancel: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            var num = 0
            for pendings in pendingSentRequest {
                if pendings.friendshipStatus == FriendshipStatus.requestSentButOnPending.rawValue {
                    num += 1
                }
            }
            return num
        case 1:
            var num = 0
            for pendings in pendingReceivedRequest {
                if pendings.friendshipStatus == FriendshipStatus.requestReceivedButOnPending.rawValue {
                    num += 1
                }
            }
            return num
        case 2:
            var num = 0
            for searchResult in searchResults {
                if searchResult.friendshipStatus == FriendshipStatus.stranger.rawValue {
                    num += 1
                }
            }
            return num
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! ResultCell
        
        switch indexPath.section {
        case 0:
            cell.content = pendingSentRequest[indexPath.row]
            return cell
        case 1:
            cell.content = pendingReceivedRequest[indexPath.row]
            return cell
        case 2:
            cell.content = searchResults[indexPath.row]
            return cell
        default:
            return cell
        }
        //cell.content = searchResults[indexPath.row]
        //return cell
    }
   
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var targetAppUser: AppUser? = nil
        switch indexPath.section {
        case 0:
            //targetAppUser = pendingSentRequest[indexPath.row]
            break
        case 1:
            targetAppUser = pendingReceivedRequest[indexPath.row]
            let alert = AlertCenter.alertAcceptFriendRequest(title: "Accept Friend Request", message: "Do you want to add him/her ?", targetAppUser: targetAppUser!, searchVC: self, selectedIndex: indexPath.row)
            present(alert, animated: true, completion: nil)
        case 2:
            targetAppUser = searchResults[indexPath.row]
            let alert = AlertCenter.alertSendFriendRequest(title: "Add Friend", message: "Do you want to send a friend request?", targetAppUser: targetAppUser!, searchVC: self, selectedIndex: indexPath.row)
            present(alert, animated: true, completion: nil)
        default:
            break
        }
        
//        let alert = AlertCenter.alertSendFriendRequest(title: "Add Friend", message: "Do you want to send a friend request?", targetAppUser: targetAppUser!, searchVC: self)
//        present(alert, animated: true, completion: nil)
    }

    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        searchResults.removeAll()
        let ref = Database.database().reference().child("users")

        ref.queryOrdered(byChild: "name").queryEqual(toValue: searchBar.text!).observeSingleEvent(of: .value, with: {[weak self] (snapshot) in
            for snap in snapshot.children {
                print(snap)
                guard let dictionary = (snap as! DataSnapshot).value as? [String: AnyObject] else {
                    print("bad snapshot")
                    return
                }
//
                let appUser = AppUser(dictionary: dictionary)
                appUser.id = (snap as! DataSnapshot).key
                
                var isStranger = true
                for pending in self!.pendingSentRequest {
                    if appUser.id == pending.id {
                        isStranger = false
                    }
                }
                for pending in self!.pendingReceivedRequest {
                    if appUser.id == pending.id {
                        isStranger = false
                    }
                }
                for pending in CurrentUserInfo.friends {
                    if appUser.id == pending.id {
                        isStranger = false
                    }
                }
                if isStranger {
                    appUser.friendshipStatus = FriendshipStatus.stranger.rawValue
                    self?.searchResults.append(appUser)
                    self?.tableView.reloadData()
                }
            }
        }, withCancel: nil)
        
    }
}


extension UITapGestureRecognizer {
    convenience init(target: Any?, action: Selector?, flag: Bool = false) {
        self.init(target: target, action: action)
        self.cancelsTouchesInView = flag
    }
    
}







//
//  HandlerLoginVC.swift
//  BuckChat
//
//  Created by Yu Wang on 2018-02-07.
//


import UIKit

class ResultCell: UITableViewCell {
    var content: AppUser? {
        didSet {
            textLabel?.text = content?.name
            detailTextLabel?.text = content?.email
            if content?.friendshipStatus != "isFriend"{
                switch content?.friendshipStatus {
                case FriendshipStatus.requestReceivedButOnPending.rawValue?:
                    statusLabel.text = "this person wants to be friends with you"
                case FriendshipStatus.requestSentButOnPending.rawValue?:
                    statusLabel.text = "friend request on pending"
                case FriendshipStatus.stranger.rawValue?:
                    statusLabel.text = content?.friendshipStatus
                default:
                    statusLabel.text = ""
                }
            }
            
            let url = URL(string: content!.profileImageUrl!)
            
            URLSession.shared.dataTask(with: url!, completionHandler: { [weak self] (data, response, error) in
                
                if let error = error {
                    print(error)
                    return
                }
                
                DispatchQueue.main.async(execute: {
                    if let downloadedImage = UIImage(data: data!) {
                        self?.profileImageView.image = downloadedImage
                    }
                })
            }).resume()
        }
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 24
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let statusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        addSubview(statusLabel)
        
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        statusLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        statusLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        statusLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        statusLabel.heightAnchor.constraint(equalTo: (textLabel?.heightAnchor)!).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 64, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
        
        detailTextLabel?.frame = CGRect(x: 64, y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
    }
}

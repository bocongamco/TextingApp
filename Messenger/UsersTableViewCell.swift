//
//  UsersTableViewCell.swift
//  Messenger
//
//  Created by Phan Thi Quynh on 14/05/2023.
//

import UIKit

class UsersTableViewCell: UITableViewCell {

    //Outlet
    
    @IBOutlet weak var avatarImage: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func configure(user: User){
        userNameLabel.text = user.username
        statusLabel.text = user.status
        setAvatar(avatarLink: user.avatarLink)
    }
    private func setAvatar(avatarLink: String){
//        Check emptu
        if avatarLink != ""{
            FileStorageFirebase.downloadImage(imageUrl: avatarLink) { avatarImg in
                self.avatarImage.image = avatarImg?.circleImage
            }
        }else{
            self.avatarImage.image = UIImage(named: "avatar")?.circleImage
        }
    }
}

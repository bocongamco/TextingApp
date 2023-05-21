//
//  ConversationTableViewCell.swift
//  Messenger
//
//  Created by Phan Thi Quynh on 21/05/2023.
//

import UIKit

class ConversationTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarOutlet: UIImageView!
    
    @IBOutlet weak var usernameOutlet: UILabel!
    
    
    @IBOutlet weak var previousMessageOutlet: UILabel!
    
    
    @IBOutlet weak var unreadMessage: UILabel!
    
    
    @IBOutlet weak var dateOutlet: UILabel!
    
    @IBOutlet weak var unreadBgOutlet: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        unreadBgOutlet.layer.cornerRadius = unreadBgOutlet.frame.width / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(recent: RecentConversation){
        usernameOutlet.text = recent.receiverName
        usernameOutlet.adjustsFontSizeToFitWidth = true
        usernameOutlet.minimumScaleFactor = 0.9
        
        previousMessageOutlet.text = recent.lastMessage
        previousMessageOutlet.adjustsFontSizeToFitWidth = true
        previousMessageOutlet.numberOfLines = 2
        previousMessageOutlet.minimumScaleFactor = 0.9
        
        if recent.unreadCounter != 0 {
            self.unreadMessage.text = "\(recent.unreadCounter)"
            self.unreadBgOutlet.isHidden = false
        }else{
            
            self.unreadBgOutlet.isHidden = true
        }
        setAva(avaLink: recent.avatarLink)
        dateOutlet.text = datentime(recent.date ?? Date())
        dateOutlet.adjustsFontSizeToFitWidth = true  
    }
    private func setAva(avaLink: String){
        if avaLink != ""{
            FileStorageFirebase.downloadImage(imageUrl: avaLink) { image in
                self.avatarOutlet.image = image?.circleImage
            }
        }else{
            self.avatarOutlet.image = UIImage(named: "avatar")?.circleImage
        }
    }
}

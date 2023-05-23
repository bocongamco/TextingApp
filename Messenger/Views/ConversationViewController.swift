//
//  ConversationViewController.swift
//  Messenger
//
//  Created by Phan Thi Quynh on 23/05/2023.
//

import UIKit
import Gallery
import MessageKit
import RealmSwift
import InputBarAccessoryView

class ConversationViewController: MessagesViewController {
    
    
    private var chatId = ""
    private var receiverId = ""
    private var receiverName = ""
    
    init(chatId: String, receiverId: String, receiverName: String){
        super.init(nibName: nil, bundle: nil)
        self.chatId = chatId
        self.receiverId = receiverId
        self.receiverName = receiverName
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


}

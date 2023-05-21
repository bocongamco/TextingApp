//
//  RecentConversation.swift
//  Messenger
//
//  Created by Phan Thi Quynh on 21/05/2023.
//

import Foundation
import FirebaseFirestoreSwift

struct RecentConversation: Codable{
    
    var id = ""
    var chatRoomId = ""
    var senderId = ""
    var senderName = ""
    var receiverId = ""
    var receiverName = ""
//  Using Firebase Timestamp instead.
    @ServerTimestamp var date = Date()
    var memberIds = [""]
    var lastMessage = ""
    var unreadCounter = 0
    var avatarLink = ""
    
}

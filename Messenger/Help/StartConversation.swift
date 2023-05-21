//
//  startConversation.swift
//  Messenger
//
//  Created by Phan Thi Quynh on 21/05/2023.
//

import Foundation
import Firebase


func StartConversation(user1: User, user2: User) -> String{
    let roomId = generateIdFrom(user1Id: user1.id, user2Id: user2.id)
    createRecentConversationObj(chatRoomId: roomId, users: [user1,user2])
    return roomId
}
func createRecentConversationObj(chatRoomId: String, users: [User]){
    var memberIdsToCreateRecent = [users.first!.id, users.last!.id]
    print("Start member list:", memberIdsToCreateRecent)
    
    //Check if user already have a current chat or not.
    // if not then proceeds to create one with other users.
    
    FirebaseReference(.Recent).whereField(KEYCHATROOMID, isEqualTo: chatRoomId).getDocuments(completion: { snapshot, error in
        guard let snapshot = snapshot else {
            return
        }
        if !snapshot.isEmpty {
            memberIdsToCreateRecent = removeUserWithRecent(snapshot: snapshot, memberId: memberIdsToCreateRecent)
            print("Update member list:", memberIdsToCreateRecent)
        }
        for id in memberIdsToCreateRecent{
            print("Userid:", id)
            //current sender is Us,
            //let senderUser = id == User.currentId ? User.currentUser! : getReceiverFrom(users: users)
            //let receiverUser = id == User.currentId? getReceiverFrom(users: users) : User.currentUser!
            let senderUser: User
            let receiverUser: User
            
            if id == User.currentId {
                senderUser = User.currentUser!
                receiverUser = getReceiverFrom(users: users)

            } else {
                senderUser = getReceiverFrom(users: users)
                receiverUser = User.currentUser!
            }
            
            let recentObj = RecentConversation(id: UUID().uuidString,chatRoomId: chatRoomId,senderId: senderUser.id, senderName: senderUser.username,receiverId: receiverUser.id,receiverName: receiverUser.username,date: Date(),memberIds: [senderUser.id,receiverUser.id],lastMessage: "",unreadCounter: 0,avatarLink: receiverUser.avatarLink)
            FirebaseRecentListener.shared.addRecent(recentObj)
        }
    })
}
func getReceiverFrom(users: [User])->User{
    var allUsers = users
    //remove the cuurent user, left with the other user.
    allUsers.remove(at: allUsers.firstIndex(of: User.currentUser!)!)
    return allUsers.first!
}

func removeUserWithRecent(snapshot: QuerySnapshot, memberId: [String]) -> [String]{
    var memberIdToCreateRecent = memberId
    
    
    for recent in snapshot.documents{
        let currentRecent = recent.data() as Dictionary
        //Check if they have a sendId, YES THEN remove it from the list
        if let currentUserId = currentRecent[KEYSENDERID] {
            if memberIdToCreateRecent.contains(currentUserId as! String){
                memberIdToCreateRecent.remove(at: memberIdToCreateRecent.firstIndex(of: currentUserId as! String)!)
            }
        }
    }
    return memberIdToCreateRecent
    
}
func generateIdFrom(user1Id: String, user2Id: String) -> String{
    var roomId = ""
    //compare so that we can have a consistent roomId no matter who's id in first.
    let value = user1Id.compare(user2Id).rawValue
    //if user1val < user 2val, else
    roomId = value < 0 ? (user1Id + user2Id) : (user2Id + user1Id)
    return roomId
    
}

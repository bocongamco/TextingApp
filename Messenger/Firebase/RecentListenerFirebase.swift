//
//  RecentListenerFirebase.swift
//  Messenger
//
//  Created by Phan Thi Quynh on 21/05/2023.
//

import Foundation
import Firebase



class FirebaseRecentListener{
    static let shared = FirebaseRecentListener()
    private init(){
        
    }
    func clearCounter(recent: RecentConversation){
        var nrecent = recent
        nrecent.unreadCounter = 0
        self.saveAllRecent(nrecent)
    }
    
    func resetCounter(roomId: String){
        //Find all recent conversation in database for that chat room id,
        //Only for current user,
        //Bc when we leave the chat, we need to reset the counter.
        //Here we get all recent for the specific roomid with specific sender id 
        FirebaseReference(.Recent).whereField(KEYCHATROOMID, isEqualTo: roomId).whereField(KEYSENDERID, isEqualTo: User.currentId).getDocuments { querySnap, error in
            guard let document = querySnap?.documents else{
                print("No convo document")
                return
            }
            let allConvo = document.compactMap{queryDocumentSnap ->RecentConversation? in
                return try? queryDocumentSnap.data(as: RecentConversation.self)
            }
            if allConvo.count > 0 {
                self.clearCounter(recent: allConvo.first!)
            }
        }
    }
    func saveAllRecent(_ recent: RecentConversation){
        do{
           try FirebaseReference(.Recent).document(recent.id).setData(from: recent)
        }
        catch{
            print("Error while saving recent chat",error.localizedDescription)
        }
    }
    func downloadRecentChats(completion: @escaping(_ allRecents: [RecentConversation])->Void){
        //Add listener to listen for any change and reponds according to it
        FirebaseReference(.Recent).whereField(KEYSENDERID, isEqualTo: User.currentId).addSnapshotListener { querysnapshot, error in
            
            var recentCons: [RecentConversation] = []
            guard let document = querysnapshot?.documents else{
                print("No docs found for recent convos")
                return
            }
            let allRecents = document.compactMap { queryDoc -> RecentConversation? in
                // try decode, if success, all queryDoc will converted into Recent Conversation, res = all Recents
                return try? queryDoc.data(as: RecentConversation.self)
            }
            for recent in allRecents{
                if recent.lastMessage != ""{
                    recentCons.append(recent)
                }
            }
            //sort by first object date must > the second object date
            recentCons.sort(by: {$0.date! > $1.date!})
            completion(recentCons)
        }
    }
    func deleteRecent(_ recent: RecentConversation){
        FirebaseReference(.Recent).document(recent.id).delete()
    }
}

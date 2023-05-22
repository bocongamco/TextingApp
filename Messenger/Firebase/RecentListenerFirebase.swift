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
    func addRecent(_ recent: RecentConversation){
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
}

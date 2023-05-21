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
}

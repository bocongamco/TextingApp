//
//  User.swift
//  Messenger
//
//  Created by Phan Thi Quynh on 07/05/2023.
//

import Foundation
import FirebaseCore
import Firebase
import FirebaseFirestoreSwift

struct User: Codable, Equatable{
    var id = ""
    var username: String
    var email: String
    var pushId = ""
    var avatarLink = ""
    var status: String
    
    
    static var currentId: String{
        return Auth.auth().currentUser!.uid
    
    }
    static var currentUser: User?{
        if Auth.auth().currentUser != nil{
            if let dic = UserDefaults.standard.data(forKey: KEYCURRENTUSER){
//                Create user object
                let decoder = JSONDecoder()
                do{
                    let userObject = try decoder.decode(User.self, from: dic)
                    return userObject
                }catch{
                    print("error trying to decoding user", error.localizedDescription)
                }
            }
        }
        return nil
    }
    static func == (lhs:User, rhs:User)->Bool{
        lhs.id == rhs.id
    }
}

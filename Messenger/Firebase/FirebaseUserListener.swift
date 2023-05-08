//
//  FirebaseUserListener.swift
//  Messenger
//
//  Created by Phan Thi Quynh on 08/05/2023.
//

import Foundation
import Firebase

class FirebaseUserListener{
    static let shared = FirebaseUserListener()
    
    private init(){
        
    }
    
    //    Login
    
    //    Register
    func registerUserWith(email: String, password: String, completion: @escaping (_ error: Error?) -> Void){
        
        Auth.auth().createUser(withEmail: email, password: password) { (authDataResult,error) in
            //Notified to completion handler
            completion(error)
            
            if error  == nil{
                authDataResult!.user.sendEmailVerification{(error) in
                    print("Auth email sent : ",error?.localizedDescription)
                    
                }
                //create user, and put it in Firebase
                if authDataResult?.user != nil{
                    let user = User(id: authDataResult!.user.uid, username: email, email: email,pushId: "",avatarLink: "",status: "Test Status")
                    
//                  JSonEncode
                    saveUserLocally(user)
                    
                    self.saveUserToFireStore(user)
                    
                }
                
            }
        }
    }
//    Save user to Firebase
//    Bc we cant directly save object to database, gotta change it to jasondecodeer and using key value pair
    func saveUserToFireStore(_ user: User){
        do{
            try FirebaseReference(.User).document(user.id).setData(from: user)
        }catch{
            print("error trying to add user to Firebase: ", error.localizedDescription)
        }
        
    }
}

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
     func loginUserWithEmail(email: String, password: String, completion: @escaping(_ error: Error?, _ isEmailVerified: Bool)-> Void){
        
        Auth.auth().signIn(withEmail: email, password: password) { (authDataResult,error) in
            if error == nil && authDataResult!.user.isEmailVerified{
                
                FirebaseUserListener.shared.downloadUserFromFirebase(userID: authDataResult!.user.uid, email: email)
                
                completion(error, true)
            }else{
                print("Email is not verified")
                completion(error, false)
            }
        }
        
    }
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
    func downloadUserFromFirebase(userID: String, email: String? = nil){
        
//      Access user
        FirebaseReference(.User).document(userID).getDocument { querySnapshot, error in
            guard let document = querySnapshot else{
                print("User document empty")
                return
            }
            let result = Result{
                try? document.data(as: User.self)
            }
            switch result{
            case .success(let userObj):
                //Check if userobject is exist then save
                if let user = userObj {
                    saveUserLocally(user)
                }else{
                    print("Document doesnt exist")
                }
            case .failure(let error):
                print("Error decoding user", error.localizedDescription)
            }
        }
    }
}

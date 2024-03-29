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
    
    
    //Resend email
    func resendVerEmail(email: String, completion: @escaping(_ error: Error?) -> Void){
        Auth.auth().currentUser?.reload(completion: { error in
            Auth.auth().currentUser?.sendEmailVerification(completion: { error in
                completion(error)
            })
        })
    }
    func resetPassword(email: String, completion: @escaping(_ error: Error?) -> Void){
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            completion(error)
        }
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
    // Log out
    func logOutCurrentUser(completion: @escaping(_ error: Error?) -> Void){
        do{
            try Auth.auth().signOut()
            userDefaults.removeObject(forKey: KEYCURRENTUSER)
            userDefaults.synchronize()
            completion(nil)
        }
        catch let error as NSError{
            completion(error)
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
    //GET ALL user from firebase
    func downloadUsersFB(completion: @escaping (_ allUsers: [User]) -> Void){
        var userList: [User] = []
        FirebaseReference(.User).limit(to: 800).getDocuments { querySnap, error in
            
            //Becasue this is key value pair user so need to transfer it to user object
            guard let doc = querySnap?.documents else{
                print("No doc in User")
                return
            }
            
            //take document and try to creaet a user object from that query doc.
            let allUsers = doc.compactMap{ (queryDocumentSnapShot) -> User? in
                //Decode anything in firebase to a User object, and add that to allUser array
                return try? queryDocumentSnapShot.data(as: User.self)
                
            }
            //All user will contain the current user, and we dont want, so we need to remove it
            for user in allUsers{
                if User.currentId != user.id{
                    userList.append(user)
                }
            }
            completion(allUsers)
        }
    }
    //get only user with specific IDs from Firebase
    func getUserIDFromFirebase(idList: [String], completion: @escaping (_ userList: [User]) -> Void){
        var count = 0
        var allUserList: [User] = []
        
        for id in idList{
            FirebaseReference(.User).document(id).getDocument { querySnap, error in
                guard let document = querySnap else{
                    print("User document empty")
                    return
                }
                let user = try? document.data(as: User.self)
                allUserList.append(user!)
                
                count += 1
                if count == idList.count{
                    completion(allUserList)
                }
            }
        }
    }
}

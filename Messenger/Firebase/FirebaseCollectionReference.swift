//
//  FirebaseCollectionReference.swift
//  Messenger
//
//  Created by Phan Thi Quynh on 08/05/2023.
//

import Foundation
import FirebaseFirestore

enum FirebaseCollectionReference: String{
    case User
    case Recent
}
func FirebaseReference(_ collectionReference: FirebaseCollectionReference)-> CollectionReference{
    
    return Firestore.firestore().collection(collectionReference.rawValue)
}

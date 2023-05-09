//
//  FileStorageFirebase.swift
//  Messenger
//
//  Created by Phan Thi Quynh on 10/05/2023.
//

import Foundation
import FirebaseStorage
import ProgressHUD
let storage = Storage.storage()

class FileStorageFirebase{
    class func uploadImage(_ image: UIImage,directory: String, completion: @escaping(_ documentLink: String?)-> Void){
        let storageRef = storage.reference(forURL: KEYFILEREFERENCE).child(directory)
        //Conver image to data
        let imageData = image.jpegData(compressionQuality: 1.0)
        
        var task: StorageUploadTask!
        
        task = storageRef.putData(imageData!,metadata: nil, completion: { metaDat, error in
            
            //Remove all obsv
            task.removeAllObservers()
            ProgressHUD.dismiss()
            
            if error != nil{
                print("Error while uploading the document\(error!.localizedDescription)")
                return
            }
            storageRef.downloadURL { url, error in
                guard let downloadUrl = url else{
                    completion(nil)
                    return
                }
                //Link to where the file was saved
                completion(downloadUrl.absoluteString)
            }
            
        })
        
        //Observe uploading percentage
        task.observe(StorageTaskStatus.progress) { snapshot in
            let progress = snapshot.progress!.completedUnitCount/snapshot.progress!.totalUnitCount
            ProgressHUD.showProgress(CGFloat(progress))
        }
    }
}

//Helpers function


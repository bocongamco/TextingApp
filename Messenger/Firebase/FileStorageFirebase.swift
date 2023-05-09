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
    
    class func downloadImage(imageUrl: String, completion: @escaping(_ image: UIImage?) -> Void){
        //print(getFileName(fileurl: imageUrl))
        let imgFileName = getFileName(fileurl: imageUrl)
        
        if fileExistsAtPath(path: imgFileName){
            print("Locally exist")
            
            if let filesContent = UIImage(contentsOfFile: fileInDocsDirectory(fileName: imgFileName)){
                completion(filesContent)
            }else{
                print("Couldnt convert to local image")
                completion(UIImage(named: "avatar"))
            }
        }else{
            //
            print("Download from database")
            if imageUrl != ""{
                let documentUrl = URL(string: imageUrl)
                let downloadQ = DispatchQueue(label: "imageDownloadQ")
                downloadQ.async {
                    let data = NSData(contentsOf: documentUrl!)
                    if data != nil{
                        FileStorageFirebase.saveFileLocally(fileData: data!, filename: imgFileName)
                        //Go back main thread
                        DispatchQueue.main.async {
                            completion(UIImage(data: data! as Data))
                        }
                        
                    }else{
                        print("No document in database")
                        DispatchQueue.main.async {
                            completion(nil)
                        }
                    }
                }
            }
        }
    }
    
    class func saveFileLocally(fileData: NSData, filename: String){
        
        let url = getDocumentsUrl().appendingPathComponent(filename,isDirectory: false)
        //atomically: Overried, successfully->delete the old file
        fileData.write(to: url,atomically: true)
        
    }
}
//get path for local file and pass it document directory
func fileInDocsDirectory(fileName: String) -> String{
    return getDocumentsUrl().appendingPathComponent(fileName).path
    
}
//Helpers function
func getDocumentsUrl() -> URL{
    //return a array of url, so only want the last one in list, which is newest one
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
}
func fileExistsAtPath(path: String) -> Bool{
    
    let filePat = fileInDocsDirectory(fileName: path)
    let fileManager = FileManager.default
    

    return fileManager.fileExists(atPath: filePat)
}

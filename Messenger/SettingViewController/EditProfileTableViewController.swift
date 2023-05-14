//
//  EditProfileTableViewController.swift
//  Messenger
//
//  Created by Phan Thi Quynh on 09/05/2023.
//

import UIKit
import Gallery
import FirebaseStorage
import ProgressHUD
class EditProfileTableViewController: UITableViewController {
    // MARK: - Outlet
        
    @IBOutlet weak var imageOutlet: UIImageView!
        
    @IBOutlet weak var userNameTextField: UITextField!
        
    @IBOutlet weak var statusOutlet: UILabel!
        
    var gallery: GalleryController!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        updateTextField()
    }
        
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showUserInfo()
    }
    
    
    // MARK: - Action
    
    @IBAction func editPressed(_ sender: Any) {
        showGallery()
    }
    
    
    // MARK: - Table View EDIT
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            // remove section number by set the color to the same with bg color
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "tableviewBackGroundColor")
        return headerView
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
//    Highlight selected row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 && indexPath.row == 2 {
            
            print("show Stauts")
            performSegue(withIdentifier: "toStatusView", sender: self)
        }
        //Show satus
    }
    
    // MARK: - Update user data
    private func showUserInfo(){
       if let user = User.currentUser{
           userNameTextField.text = user.username
           statusOutlet.text = user.status
           if user.avatarLink != ""{
               FileStorageFirebase.downloadImage(imageUrl: user.avatarLink) { avatarimage in
                   self.imageOutlet.image = avatarimage?.circleImage
               }
           }
       }
   }
    private func showGallery(){
        self.gallery = GalleryController()
        self.gallery.delegate = self
        Config.tabsToShow = [.imageTab,.cameraTab]
        Config.Camera.imageLimit = 1
        Config.initialTab = .imageTab
        
        self.present(gallery,animated: true,completion: nil)
    }
    //UploadImg
    private func uploadAvaImg(_ image: UIImage){
        //Creaet avatars folder
        let fileDirec = "Avatars/" + "_\(User.currentId)" + ".jpg"
        FileStorageFirebase.uploadImage(image, directory: fileDirec) { avatarLink in
            //Check if theres user
            
            if var user = User.currentUser{
                user.avatarLink = avatarLink ?? ""
                saveUserLocally(user)
                FirebaseUserListener.shared.saveUserToFireStore(user)
            }
//            Save image locally
            FileStorageFirebase.saveFileLocally(fileData: image.jpegData(compressionQuality: 1.0)! as  NSData, filename: User.currentId)
        }
    }
    
    private func updateTextField(){
        userNameTextField.delegate = self
        
    }
}
extension EditProfileTableViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == userNameTextField{
            if textField.text != ""{
                if var user = User.currentUser{
                    user.username = textField.text!
                    saveUserLocally(user)
                    FirebaseUserListener.shared.saveUserToFireStore(user)
                }
            }
            textField.resignFirstResponder()
            return false
        }
        return true
    }
}
//Upload to firebase
//Getlink and assigned to user
//Update it to user
//Finally set the image avatar
extension EditProfileTableViewController : GalleryControllerDelegate{
    func galleryController(_ controller: Gallery.GalleryController, didSelectImages images: [Gallery.Image]) {
        if images.count > 0{
            //Can force unwrapped cuz we alwasy have a value
            //Get first img and resolve it and called it async
            images.first!.resolve { avatarImg in
                
                // Upload to Firebase
                if avatarImg != nil{
                    self.uploadAvaImg(avatarImg!)
                    self.imageOutlet.image = avatarImg?.circleImage
                }else{
                    ProgressHUD.showError("Couldnt Select the image!")
                }
                
            }
        }
        controller.dismiss(animated: true,completion: nil)
    }
    
    func galleryController(_ controller: Gallery.GalleryController, didSelectVideo video: Gallery.Video) {
        controller.dismiss(animated: true,completion: nil)
    }
    
    func galleryController(_ controller: Gallery.GalleryController, requestLightbox images: [Gallery.Image]) {
        controller.dismiss(animated: true,completion: nil)
    }
    
    func galleryControllerDidCancel(_ controller: Gallery.GalleryController) {
        controller.dismiss(animated: true,completion: nil)
    }
    
    
}

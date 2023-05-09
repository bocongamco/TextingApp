//
//  EditProfileTableViewController.swift
//  Messenger
//
//  Created by Phan Thi Quynh on 09/05/2023.
//

import UIKit

class EditProfileTableViewController: UITableViewController {
    // MARK: - Outlet
        
    @IBOutlet weak var imageOutlet: UIImageView!
        
    @IBOutlet weak var userNameTextField: UITextField!
        
    @IBOutlet weak var statusOutlet: UILabel!
        
        
        
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        updateTextField()
    }
        
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showUserInfo()
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
        
        //Show satus
    }
    
    // MARK: - Table view data source
    private func showUserInfo(){
       if let user = User.currentUser{
           userNameTextField.text = user.username
           statusOutlet.text = user.status
           if user.avatarLink != ""{
               
           }
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

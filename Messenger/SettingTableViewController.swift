//
//  SettingTableViewController.swift
//  Messenger
//
//  Created by Phan Thi Quynh on 09/05/2023.
//

import UIKit

class SettingTableViewController: UITableViewController {
    // MARK: - Outlet
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var avatarImage: UIImageView!
    
    @IBOutlet weak var versionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//      Remove all empty cell
        tableView.tableFooterView = UIView()
        
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showUserInformation()
    }
    
    
    // MARK: - Helper function
    private func showUserInformation(){
        if let user = User.currentUser{
            usernameLabel.text = user.username
            statusLabel.text = user.status
            versionLabel.text = "Current version is: \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")"
            if user.avatarLink != ""{
//                Download and change avatar
            }
        }
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
    
    // MARK: - Action

    @IBAction func chatPressed(_ sender: Any) {
        print("Chat button Pressed")
    }
    
    @IBAction func aboutPressed(_ sender: Any) {
        print("About button Pressed")
    }
    
    @IBAction func logOutPressed(_ sender: Any) {
        print("logOutPressed button Pressed")
        FirebaseUserListener.shared.logOutCurrentUser { error in
            if error == nil{
                let loginViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginViewController")
                // Do it in background thread
                DispatchQueue.main.async {
                    loginViewController.modalPresentationStyle = .fullScreen
                    self.present(loginViewController,animated: true, completion: nil)
                }
            }
        }
    }
    
}

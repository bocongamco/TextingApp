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
        showInformation()
    }
    
    
    // MARK: - Helper function
    private func showInformation(){
        
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
    }
    
}

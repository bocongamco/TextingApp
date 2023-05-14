//
//  StatusTableViewController.swift
//  Messenger
//
//  Created by Phan Thi Quynh on 13/05/2023.
//

import UIKit

class StatusTableViewController: UITableViewController {
    
    var allStatus: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        loadUserStatus()
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return allStatus.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",for: indexPath)
        
        let status = allStatus[indexPath.row]
        cell.textLabel?.text = status
        cell.accessoryType = User.currentUser?.status == status ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        updateCell(indexPath)
        tableView.reloadData()
    }
    
    private func loadUserStatus(){
        allStatus = userDefaults.object(forKey: KSTATUS) as! [String]
        tableView.reloadData()
    }
    private func updateCell(_ indexPath: IndexPath){
        if var user = User.currentUser{
            user.status = allStatus[indexPath.row]
            saveUserLocally(user)
            FirebaseUserListener.shared.saveUserToFireStore(user)
        }
    }
}

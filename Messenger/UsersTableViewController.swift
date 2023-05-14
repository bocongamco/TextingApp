//
//  UsersTableViewController.swift
//  Messenger
//
//  Created by Phan Thi Quynh on 14/05/2023.
//

import UIKit

class UsersTableViewController: UITableViewController {

    
    
    var allUsers: [User] = []
    var filteredUsers: [User] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllUser()
        
//        createUserExample()
        
    }
    
    // MARK: - Table view data source
    
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if searchController.isActive{
            return filteredUsers.count
        }
        else{
            return allUsers.count
        }
    }

    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Because we using a custom cell, User custome cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! UsersTableViewCell
        let user = searchController.isActive ? filteredUsers[indexPath.row] : allUsers[indexPath.row]
        // Configure the cell...
        cell.configure(user: user)
        return cell
    }
    private func getAllUser(){

        FirebaseUserListener.shared.downloadUsersFB { (allUsersFB) in
            
            //This now in background thread
            self.allUsers = allUsersFB
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

}

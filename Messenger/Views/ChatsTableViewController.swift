//
//  ChatsTableViewController.swift
//  Messenger
//
//  Created by Phan Thi Quynh on 22/05/2023.
//

import UIKit

class ChatsTableViewController: UITableViewController, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filteredUserForSearch(searchText: searchController.searchBar.text!)
    }
    private func filteredUserForSearch(searchText: String){
        filteredConvo = allConvo.filter({ recent -> Bool in
            return recent.receiverName.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    var allConvo: [RecentConversation] = []
    var filteredConvo: [RecentConversation] = []
    let searchController = UISearchController(searchResultsController: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar()
        //Hide empty cell
        tableView.tableFooterView = UIView()
        downloadConvo()
    }
    
    // MARK: - Table view data source
    
    
    private func downloadConvo(){
        FirebaseRecentListener.shared.downloadRecentChats { allRecents in
            self.allConvo = allRecents
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    private func searchBar(){
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "User name"
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive{
            return filteredConvo.count
        }
        else{
            return allConvo.count
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConvoCell", for: indexPath) as! ConversationTableViewCell
        let recent = searchController.isActive ? filteredConvo[indexPath.row] : allConvo[indexPath.row]

        cell.configure(recent: recent)
        return cell
    }
    
}

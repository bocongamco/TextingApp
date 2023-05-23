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
    
    @IBAction func startWritingBtn(_ sender: Any) {
        let userViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserTableViewC") as! UsersTableViewController
        navigationController?.pushViewController(userViewController, animated: true)
    }
    
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
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let recent: RecentConversation

        if searchController.isActive {
            recent = filteredConvo[indexPath.row]
        } else {
            recent = allConvo[indexPath.row]
        }
        
        FirebaseRecentListener.shared.clearCounter(recent: recent)
        navigateToChat(recent: recent)
        
    }
    private func navigateToChat(recent: RecentConversation){
        //Might only have 1 recent when one of them delete the covo,
        // Need to make sure it alwayss have 2 recent
        RestartConversation(roomId: recent.chatRoomId, MemIdList: recent.memberIds)
        let privateConView = ConversationViewController(chatId: recent.chatRoomId, receiverId: recent.receiverId, receiverName: recent.receiverName)
        navigationController?.pushViewController(privateConView, animated: true)
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive{
            return filteredConvo.count
        }
        else{
            return allConvo.count
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let convo = searchController.isActive ? filteredConvo[indexPath.row] : allConvo[indexPath.row]
            FirebaseRecentListener.shared.deleteRecent(convo)
            if searchController.isActive{
                self.filteredConvo.remove(at: indexPath.row)
            }
            else{
                self.allConvo.remove(at: indexPath.row)
            }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConvoCell", for: indexPath) as! ConversationTableViewCell
        let recent: RecentConversation

        if searchController.isActive {
            recent = filteredConvo[indexPath.row]
        } else {
            recent = allConvo[indexPath.row]
        }

        cell.configure(recent: recent)
        return cell
    }
    
}

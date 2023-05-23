//
//  ProfileTableViewController.swift
//  Messenger
//
//  Created by Phan Thi Quynh on 15/05/2023.
//

import UIKit

class ProfileTableViewController: UITableViewController {

    @IBOutlet weak var avatarImgOutlet: UIImageView!
    
    @IBOutlet weak var usernameOutlet: UILabel!
    
    @IBOutlet weak var statusOutlet: UILabel!
    
    var user: User?
    
    
//    Modified the tableview
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
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1{
            
            let chatId = StartConversation(user1: User.currentUser!, user2: user!)
            print("test section id",chatId)
            let privateConvo = ConversationViewController(chatId: chatId, receiverId: user!.id, receiverName: user!.username)
            navigationController?.pushViewController(privateConvo, animated: true)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        navigationItem.largeTitleDisplayMode = .never
        tableView.tableFooterView = UIView()
        showFullDetail()
    }
    private func showFullDetail(){
        if user != nil{
            self.title = user?.username
            usernameOutlet.text = user?.username
            statusOutlet.text = user?.status
            if user!.avatarLink != ""{
                FileStorageFirebase.downloadImage(imageUrl: user!.avatarLink) { image in
                    self.avatarImgOutlet.image = image?.circleImage
                }
            }
        }
    }
    
}

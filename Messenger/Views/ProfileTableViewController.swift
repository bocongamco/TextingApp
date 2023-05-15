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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    
}

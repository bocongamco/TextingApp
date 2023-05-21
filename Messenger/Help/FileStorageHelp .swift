//
//  FileStorageHelp .swift
//  Messenger
//
//  Created by Phan Thi Quynh on 10/05/2023.
//

import Foundation
func getFileName(fileurl: String) -> String{
    //Split everything in url from _
    var name = fileurl.components(separatedBy: "_").last
    // split everything after ?
    name = name?.components(separatedBy: "?").first
    
    // remove dot
    name = name?.components(separatedBy: ".").first
    return name!
}
func datentime(_ date: Date) -> String{
    //Get the time
    let second = Date().timeIntervalSince(date)
    var messageStatus = ""
    if second < 60{
        messageStatus = "Just now"
    }
    else if second < 3600{
        let minutes = Int(second/60)
        let text = minutes > 1 ? "mins" : "min"
        messageStatus = "\(minutes) " + text
    }
    // a day
    else if second < 86400{
        let hours = Int(second/3600)
        let hrsText = hours > 1 ? "hours" : "hour"
        messageStatus = "\(hours)" + hrsText
    }
    else{
        messageStatus  = date.longDate()
    }
    return messageStatus
}

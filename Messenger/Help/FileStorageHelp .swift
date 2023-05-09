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

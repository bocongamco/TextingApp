//
//  Status.swift
//  Messenger
//
//  Created by Phan Thi Quynh on 13/05/2023.
//

import Foundation

enum Status: String{
    case Available = "Available"
    case Idle = "Idle"
    case DoNotDisturb = "Do Not Disturb"
    case Offline = "Offline"
    
    static var array : [Status]{
        var a: [Status] = []
        switch Status.Available{
        case .Available:
                a.append(.Available);fallthrough
        case .Idle:
                a.append(.Idle);fallthrough
        case .DoNotDisturb:
                a.append(.DoNotDisturb);fallthrough
        case .Offline:
                a.append(.Offline)
        return a
        }
    }
}

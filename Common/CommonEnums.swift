//
//  CommonEnums.swift
//  iOSChatSystemClient
//
//  Created by Dmitrii Titov on 03.03.2018.
//  Copyright © 2018 Dmitriy Titov. All rights reserved.
//

import Foundation

enum ServerManagerMethod: String {
    case ConnectClient = "connect_client"
    case ConnectToServer = "connect_to_server"
    case ConnectServer = "connect_server"
    case Ping = "ping"
    case Unknown = "unknown"
}

enum ServerMethod: String {
    case ConnectClient = "connect_client"
    case ConnectServerManager = "connect_server_manager"
    case ReceiveMessage = "receive_message"
    case Ping = "ping"
    case Unknown = "unknown"
    
    enum Socket: String {
        case LoadRooms = "load_rooms"
        case UpdateUser = "update_user"
        case Unknown = "unknown"
    }
}

enum ClientsMethod: String {
    case ReceiveMessage = "receive_message"
    case Ping = "ping"
    case Unknown = "unknown"
    
    case SocketReceiveRooms = "receive_rooms"
}

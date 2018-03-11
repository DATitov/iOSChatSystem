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
    case GetUser = "get_user"
    case CreateRoom = "create_room"
    case Unknown = "unknown"
    
    enum Socket: String {
        case LoadRooms = "load_rooms"
        case LoadUsers = "load_users"
        case UpdateUser = "update_user"
        case Unknown = "unknown"
    }
}

enum ClientsMethod: String {
    case ReceiveMessage = "receive_message"
    case ReceiveChatMessage = "receive_chat_message"
    case Ping = "ping"
    case Unknown = "unknown"
    
    enum Socket: String {
        case ReceiveRooms = "receive_rooms"
        case ReceiveUsers = "receive_users"
        case Unknown = "unknown"
    }
    
    enum Room: String {
        case ReceiveMessage = "receive_message"
        case GetMessages = "get_messages"
        case Ping = "ping"
        case Unknown = "unknown"
    }
}

//
//  ChannelListModel.swift
//  Icewrap Test
//

import Foundation


struct ChannelResponse: Codable {
    let channels: [ChannelGroup]?
}

struct ChannelGroup: Codable {
    let groupFolderName: String?
    let header: String?
    var items: [Channel]?
    var isSelected: Bool = false
}


struct Channel: Codable {
    let channelId: String?
    let channelName: String?
    let channelDescription: String?
    var isSelected: Bool = false
}



struct RawChannelResponse: Codable {
    let rawChannels: [RawChannel]?
    
    enum CodingKeys: String, CodingKey {
        case rawChannels = "channels"
    }
}

struct RawChannel: Codable {
    let id: String?
    let name: String?
    let groupFolderName: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case groupFolderName = "group_folder_name"
    }
}

func parseChannels(channels: [RawChannel]) -> ChannelResponse? {
    let groupedChannels = Dictionary(grouping: channels) { $0.groupFolderName }
    var channelGroups: [ChannelGroup] = []
    for (groupFolderName, channels) in groupedChannels {
        let channelItems = channels.map { channel in
            Channel(
                channelId: channel.id,
                channelName: channel.name,
                channelDescription: nil
            )
        }
        let channelGroup = ChannelGroup(
            groupFolderName: groupFolderName,
            header: nil,
            items: channelItems
        )
        channelGroups.append(channelGroup)
    }
    return ChannelResponse(channels: channelGroups)
}




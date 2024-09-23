//
//  CoreDataManager.swift
//  Icewrap Test
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {

    static let shared = CoreDataManager()
    
    private init() {}

    var context: NSManagedObjectContext {
        return CoreStack.shared.persistentContainer.viewContext
    }
    
    // MARK: - ChannelResponse Operations

    // Insert a ChannelResponse and nested data
    func insertChannelResponse(channelResponse: ChannelResponse)  {
        let newChannelResponse = NSEntityDescription.insertNewObject(forEntityName: "ChannelResponseEntity", into: context) as! ChannelResponseEntity
        
        if let channelGroups = channelResponse.channels {
            for group in channelGroups {
                let newGroup = NSEntityDescription.insertNewObject(forEntityName: "ChannelGroupEntity", into: context) as! ChannelGroupEntity
                newGroup.groupFolderName = group.groupFolderName
                newGroup.header = group.header
                newGroup.isSelected = group.isSelected
                
                if let channels = group.items {
                    for channel in channels {
                        let newChannel = NSEntityDescription.insertNewObject(forEntityName: "ChannelEntity", into: context) as! ChannelEntity
                        newChannel.channelId = channel.channelId
                        newChannel.channelName = channel.channelName
                        newChannel.channelDescription = channel.channelDescription
                        newChannel.isSelected = channel.isSelected
                        
                        newGroup.addToItems(newChannel)
                    }
                }
                newChannelResponse.addToChannels(newGroup)
            }
        }
        
        do {
            try context.save()
        } catch {
            print("Failed to save ChannelResponse: \(error)")
        }
    }
    
    // Fetch all ChannelResponse
    func fetchAllChannelResponses() -> [ChannelResponseEntity]? {
        let fetchRequest = NSFetchRequest<ChannelResponseEntity>(entityName: "ChannelResponseEntity")
        
        do {
            let results = try context.fetch(fetchRequest)
            return results
        } catch {
            print("Failed to fetch ChannelResponses: \(error)")
            return nil
        }
    }
    
    // Delete a specific ChannelResponse
    func deleteChannelResponse(channelResponse: ChannelResponseEntity) throws {
        context.delete(channelResponse)
        
        do {
            try context.save()
        } catch let error {
            throw error
        }
    }
}

extension CoreDataManager {
    func getChannelResponse(from entity: ChannelResponseEntity) -> ChannelResponse {
        var channelGroups: [ChannelGroup] = []
        
        if let groups = entity.channels?.allObjects as? [ChannelGroupEntity] {
            for groupEntity in groups {
                var channels: [Channel] = []
                
                if let channelEntities = groupEntity.items?.allObjects as? [ChannelEntity] {
                    for channelEntity in channelEntities {
                        let channel = Channel(
                            channelId: channelEntity.channelId,
                            channelName: channelEntity.channelName,
                            channelDescription: channelEntity.channelDescription,
                            isSelected: channelEntity.isSelected
                        )
                        channels.append(channel)
                    }
                }
                
                let group = ChannelGroup(
                    groupFolderName: groupEntity.groupFolderName,
                    header: groupEntity.header,
                    items: channels,
                    isSelected: groupEntity.isSelected
                )
                channelGroups.append(group)
            }
        }
        
        return ChannelResponse(channels: channelGroups)
    }
    
    func fetchChannelResponse() -> ChannelResponse? {
        let fetchRequest = NSFetchRequest<ChannelResponseEntity>(entityName: "ChannelResponseEntity")
        
        do {
            if let result = try context.fetch(fetchRequest).first {
                return getChannelResponse(from: result)
            } else {
                print("No ChannelResponseEntity found")
                return nil
            }
        } catch {
            print("Failed to fetch ChannelResponse: \(error)")
            return nil
        }
    }

}

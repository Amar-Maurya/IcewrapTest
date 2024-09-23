//
//  AppFlowBuilder.swift
//  Icewrap Test
//

import Foundation
import UIKit

class AppFlowBuilder {
    
    static let shared = AppFlowBuilder()
    
    func startAppFlow() {
        if let token = KeyChainManager.shared.token {
            let channelListViewModel = ChannelListViewModel(token: token)
            AppCoordinator.shared.showChannelList(viewModel: channelListViewModel)
        } else {
            AppCoordinator.shared.showLogin()
        }
    }
    
    func logout() {
        KeyChainManager.shared.token = nil
        if let channelResponse = CoreDataManager.shared.fetchAllChannelResponses()?.first {
            do {
                try CoreDataManager.shared.deleteChannelResponse(channelResponse: channelResponse)
            } catch let error {
               print(error)
            }
        }
    }
}

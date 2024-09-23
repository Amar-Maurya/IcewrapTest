//
//  ChannelListViewModel.swift
//  Icewrap Test
//

import Foundation

protocol ChannelListViewModelDelegate {
    func onSuccess()
    func onError(error: Error)
}

class ChannelListViewModel {
    
    private var channelResponse: ChannelResponse?
    var delegate: ChannelListViewModelDelegate?
    private var token: String?
    init(token: String) {
        self.token = token
    }
    
    func getChannelGroup() -> [ChannelGroup] {
        return channelResponse?.channels ?? []
    }
}

extension ChannelListViewModel {
    
    func callChannelListAPI() {
        Task {
            let apiParameters: [String: Any] = [
                "token": token ?? "",
                "include_unread_count": true,
                "exclude_members": true,
                "include_permissions": false
            ]
            do {
                if let rawChannelResponse: RawChannelResponse = try await NetworkManager.shared.postFormEncoded(urlEndPoint: Constants.EndPoint.channelList, parameters: apiParameters),
                   let channelResponse = parseChannels(channels: rawChannelResponse.rawChannels ?? []) {
                    self.channelResponse = channelResponse
                    CoreDataManager.shared.insertChannelResponse(channelResponse: channelResponse)
                    self.delegate?.onSuccess()
                }
            } catch let error {
                if let channelResponse = CoreDataManager.shared.fetchChannelResponse() {
                    self.channelResponse = channelResponse
                    self.delegate?.onSuccess()
                } else {
                    self.delegate?.onError(error: error)
                }
                
            }
        }
    }
    
}


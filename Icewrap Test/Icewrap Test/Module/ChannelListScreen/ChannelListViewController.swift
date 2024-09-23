//
//  ChannelListViewController.swift
//  Icewrap Test
//

import UIKit

class ChannelListViewController: UIViewController {
    @IBOutlet weak var channelListTV: UITableView!
    @IBOutlet weak var noDataAvailabel: UILabel!
    
    var channels: [ChannelGroup] = []
    var viewModel: ChannelListViewModel?
    var selectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCell()
        setUpViewModel()
        }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppFlowBuilder.shared.logout()
    }

    func setUpCell() {
        channelListTV.register(UINib(nibName: "ChannelListTVCell", bundle: nil), forCellReuseIdentifier: "ChannelListTVCell")
        channelListTV.register(UINib(nibName: "ChannelListHeaderView", bundle: nil), forCellReuseIdentifier: "ChannelListHeaderView")
    }
    
    func setUpViewModel() {
        DispatchQueue.main.async { [weak self] in
            self?.showLoadingIndicator()
        }
        viewModel?.callChannelListAPI()
        viewModel?.delegate = self
    }
}

extension ChannelListViewController: ChannelListHeaderDelegate {
    
    func headerViewSelected(index: Int) {
        let isSelected = channels[index].isSelected
        channels[index].isSelected = !isSelected
        channelListTV.reloadSections(IndexSet(integer: index), with: .automatic)
    }
}

extension ChannelListViewController: ChannelListViewModelDelegate {
    func onSuccess() {
        DispatchQueue.main.async { [weak self] in
            self?.hideLoadingIndicator()
            self?.channels = self?.viewModel?.getChannelGroup() ?? []
            self?.noDataAvailabel.isHidden = self?.channels.count != 0
            self?.channelListTV.reloadData()
        }
    }
    
    func onError(error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.hideLoadingIndicator()
            self?.noDataAvailabel.isHidden = false
            self?.channelListTV.reloadData()
        }
    }
}

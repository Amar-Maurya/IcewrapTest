//
//  ChannelListVC+TableView+Ext.swift
//  Icewrap Test
//
//  Created by 2674143 on 21/09/24.
//

import Foundation
import UIKit

extension ChannelListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return channels.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels[section].items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChannelListTVCell") as? ChannelListTVCell
        else { return UITableViewCell() }
        if let item = channels[indexPath.section].items?[indexPath.row] {
            cell.configure(with: item)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = Bundle.main.loadNibNamed("ChannelListHeaderView", owner: self, options: nil)?.first as? ChannelListHeaderView else { return UIView() }
        let sectionItem = channels[section]
        headerView.configure(with: sectionItem.groupFolderName ?? "", isExpanded: sectionItem.isSelected, sectionIndex: section)
        headerView.delegate = self
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  channels[indexPath.section].isSelected ? 0 : UITableView.automaticDimension
    }
    
}

extension ChannelListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedIndexPath = self.selectedIndexPath, selectedIndexPath == indexPath {
            channels[indexPath.section].items?[indexPath.row].isSelected = false
            self.selectedIndexPath = nil
        } else {
            if let previousIndexPath = self.selectedIndexPath {
                channels[previousIndexPath.section].items?[previousIndexPath.row].isSelected = false
                tableView.reloadRows(at: [previousIndexPath], with: .automatic)
            }
            channels[indexPath.section].items?[indexPath.row].isSelected = true
            self.selectedIndexPath = indexPath
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
}

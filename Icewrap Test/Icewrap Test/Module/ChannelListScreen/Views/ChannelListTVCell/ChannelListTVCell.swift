//
//  ChannelListTVCell.swift
//  Icewrap Test
//

import UIKit

class ChannelListTVCell: UITableViewCell {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var mainView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with channel: Channel) {
        titleLbl.text = channel.channelName
        mainView.backgroundColor = channel.isSelected ? UIColor.lightGray.withAlphaComponent(0.5) : .clear
    }
    
}

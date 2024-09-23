//
//  ChannelListHeaderView.swift
//  Icewrap Test
//


import UIKit

protocol ChannelListHeaderDelegate {
    func headerViewSelected(index: Int)
}

class ChannelListHeaderView: UIView {
    
    @IBOutlet weak var channelNameLbl: UILabel!
    @IBOutlet weak var headerArrowImg: UIImageView!
    var section: Int = 0
    var delegate: ChannelListHeaderDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with groupFolderName: String, isExpanded: Bool, sectionIndex: Int) {
        channelNameLbl.text = groupFolderName
        headerArrowImg.image = isExpanded ? UIImage(named: "down-arrow") : UIImage(named: "up-arrow")
        section = sectionIndex
    }
    
    @IBAction func selectionButton(_ button: UIButton) {
        delegate?.headerViewSelected(index: section)
    }
}

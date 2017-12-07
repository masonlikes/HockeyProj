//
//  PlayTableViewCell.swift
//  Hockey Project
//
//  Created by Mason Lawrence on 12/5/17.
//

import UIKit

class PlayTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lastPlay: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

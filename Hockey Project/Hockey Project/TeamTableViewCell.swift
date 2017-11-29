//
//  TeamTableViewCell.swift
//  Hockey Project
//
//  Created by Mason Lawrence on 11/14/17.
//

import UIKit

class TeamTableViewCell: UITableViewCell {
    //MARK: Properties
    
    @IBOutlet weak var teamName: UILabel!
    @IBOutlet weak var teamLogo: UIImageView!
    @IBOutlet weak var followSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func followTeam(_ sender: Any) {
        print(teamName.text ?? "")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

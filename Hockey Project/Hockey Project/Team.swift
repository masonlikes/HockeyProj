//
//  Team.swift
//  Hockey Project
//
//  Created by Mason Lawrence on 11/14/17.
//

import UIKit

class Team:NSObject {
    
    //MARK: Properties
    
    var teamName: String
    var teamLogo: UIImage?
    var followed: Bool
    
    //MARK: Initialization
    
    init(teamName: String, teamLogo: UIImage?, followed: Bool) {
        self.teamName = teamName
        self.teamLogo = teamLogo
        self.followed = followed
    }
}

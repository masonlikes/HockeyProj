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
    var teamId: Int
    var followed: Bool
    
    //MARK: Initialization
    
    init(teamName: String, teamLogo: UIImage?, teamId: Int, followed: Bool) {
        self.teamName = teamName
        self.teamLogo = teamLogo
        self.teamId = teamId
        self.followed = followed
    }
}

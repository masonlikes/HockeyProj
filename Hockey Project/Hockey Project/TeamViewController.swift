//
//  ViewController.swift
//  Hockey Project
//
//  Created by Mason Lawrence on 11/9/17.
//

import UIKit

class TeamViewController: UIViewController {
    
    var urlString = "https://statsapi.web.nhl.com/api/v1/teams";

    var venueName: String = ""
    var firstYearOfPlay: String = ""
    var conName: String = ""
    var divName: String = ""
    
    @IBOutlet weak var teamName: UILabel!
    @IBOutlet weak var teamLogo: UIImageView!
    @IBOutlet weak var followed: UILabel!
    
    @IBOutlet weak var teamVenue: UILabel!
    @IBOutlet weak var firstYear: UILabel!
    @IBOutlet weak var teamConference: UILabel!
    @IBOutlet weak var teamDivision: UILabel!
    
    //A string array to save all the names
    
    var team: Team = Team(teamName: "", teamLogo: UIImage(named:"KINGS"), teamId: 0, followed: false);

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print(team.teamId)
        urlString += "/\(team.teamId)"
        self.teamName.text = team.teamName
        self.teamLogo.image = team.teamLogo
        if(team.followed){
            self.followed.text = "Followed"
        }
        //getJsonFromUrl();
        //getJSON()
        getStuff(teamUrl: urlString)
        self.teamVenue.text = "Venue: "+self.venueName;
        self.firstYear.text = "First Year of Play: "+self.firstYearOfPlay;
        self.teamConference.text = "Conference: "+self.conName;
        self.teamDivision.text = "Division: "+self.divName;
        print("hell0")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getStuff(teamUrl: String){
        let url = URL(string: teamUrl)
        URLSession.shared.dataTask(with:url!) { (data, response, error) in
            if error != nil {
                print(error as Any)
            } else {
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: data!) as! NSDictionary
                    //let team = parsedData.value(forKey: "teams") as! NSDictionary
                    let team = (parsedData["teams"]! as! NSArray).mutableCopy() as! NSMutableArray
                    
                    print(team)
                    
                    let teamData = team[0] as! NSDictionary
                    
                    self.firstYearOfPlay = teamData["firstYearOfPlay"] as! String
                    
                    let venue = teamData["venue"] as! NSDictionary
                    self.venueName = venue["name"] as! String
                    
                    let division = teamData["division"] as! NSDictionary
                    self.divName = division["name"] as! String
                    
                    let conference = teamData["conference"] as! NSDictionary
                    self.conName = conference["name"] as! String
                    
                    print(self.firstYearOfPlay)
                    print(self.venueName)
                    print(self.divName)
                    print(self.conName)
                    DispatchQueue.main.async { // Correct
                        self.teamVenue.text = "Venue: "+self.venueName;
                        self.firstYear.text = "First Year of Play: "+self.firstYearOfPlay;
                        self.teamConference.text = "Conference: "+self.conName;
                        self.teamDivision.text = "Division: "+self.divName;
                    }
                } catch let error as NSError {
                    print(error)
                }
            }
            
            }.resume()
    }
}

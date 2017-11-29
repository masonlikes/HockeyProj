//
//  ViewController.swift
//  Hockey Project
//
//  Created by Mason Lawrence on 11/9/17.
//

import UIKit

class TeamViewController: UIViewController {
    
    var urlString = "https://statsapi.web.nhl.com/api/v1/teams";

    var venueLoc: String = ""
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
        printGameData()
        print("hell0")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func printGameData(){
        let url = URL(string: "https://statsapi.web.nhl.com/api/v1/game/2017020376/feed/live")
        URLSession.shared.dataTask(with:url!) { (data, response, error) in
            if error != nil {
                print(error as Any)
            } else {
                do {
                    
                    let parsed = try JSONSerialization.jsonObject(with: data!) as! NSDictionary
                    //stuff
                    let liveData = parsed["liveData"] as! NSDictionary
                    
                    let plays = liveData["plays"] as! NSDictionary
                    
                    let currPlay = plays["currentPlay"] as! NSDictionary
                    
                    let about = currPlay["about"] as! NSDictionary
                    let coordinates = currPlay["coordinates"] as! NSDictionary
                    if(!coordinates.allKeys.isEmpty){
                        let xCord = coordinates["x"] as! Int
                        let yCord = coordinates["y"] as! Int
                        
                        print(xCord)
                        print(yCord)
                    }
                    if let players = currPlay["players"] as? NSArray{
                        //print(players)
                        print(players.count)
                        if(players.count == 4){
                            let player1 = players[0] as! NSDictionary
                            let player1Obj = player1["player"] as! NSDictionary
                            let player1Data = player1Obj["fullName"] as! String
                            
                            let player2 = players[1] as! NSDictionary
                            let player2Obj = player2["player"] as! NSDictionary
                            let player2Data = player2Obj["fullName"] as! String
                            
                            let player3 = players[2] as! NSDictionary
                            let player3Obj = player3["player"] as! NSDictionary
                            let player3Data = player3Obj["fullName"] as! String
                            
                            let player4 = players[3] as! NSDictionary
                            let player4Obj = player4["player"] as! NSDictionary
                            let player4Data = player4Obj["fullName"] as! String
                            
                            print(player1Data)
                            print(player2Data)
                            print(player3Data)
                            print(player4Data)
                        }else if(players.count == 3){
                            let player1 = players[0] as! NSDictionary
                            let player1Obj = player1["player"] as! NSDictionary
                            let player1Data = player1Obj["fullName"] as! String
                            
                            let player2 = players[1] as! NSDictionary
                            let player2Obj = player2["player"] as! NSDictionary
                            let player2Data = player2Obj["fullName"] as! String
                            
                            let player3 = players[2] as! NSDictionary
                            let player3Obj = player3["player"] as! NSDictionary
                            let player3Data = player3Obj["fullName"] as! String
                            
                            print(player1Data)
                            print(player2Data)
                            print(player3Data)
                        }else if(players.count == 2){
                            let player1 = players[0] as! NSDictionary
                            let player1Obj = player1["player"] as! NSDictionary
                            let player1Data = player1Obj["fullName"] as! String
                            
                            let player2 = players[1] as! NSDictionary
                            let player2Obj = player2["player"] as! NSDictionary
                            let player2Data = player2Obj["fullName"] as! String
                            
                            print(player1Data)
                            print(player2Data)
                        }else if(players.count == 1){
                            let player1 = players[0] as! NSDictionary
                            let player1Obj = player1["player"] as! NSDictionary
                            let player1Data = player1Obj["fullName"] as! String
                            
                            print(player1Data)
                        }
                    }
                    let result = currPlay["result"] as! NSDictionary
                    if let team = currPlay["team"] as? NSDictionary{
                        let teamName = team["name"] as! String
                        print(teamName)
                    }
                    
                    let goals = about["goals"] as! NSDictionary
                    
                    let homeScore = goals["home"] as! Int
                    let awayScore = goals["away"] as! Int
                    
                    let event = result["event"] as! String
                    let description = result["description"] as! String
                    let period = about["ordinalNum"] as! String
                    let periodTime = about["periodTime"] as! String
                    
                    print("You are here")
                    
                    print(homeScore)
                    print(awayScore)
                    
                    print(event)
                    print(description)
                    print(period)
                    print(periodTime)
                    
                } catch let error as NSError {
                    print(error)
                }
            }
            
            }.resume()
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
                    
                    //print(team)
                    
                    let teamData = team[0] as! NSDictionary
                    
                    self.firstYearOfPlay = teamData["firstYearOfPlay"] as! String
                    
                    let venue = teamData["venue"] as! NSDictionary
                    self.venueLoc = venue["name"] as! String
                    self.venueLoc += ", \(venue["city"] as! String)"
                    
                    let division = teamData["division"] as! NSDictionary
                    self.divName = division["name"] as! String
                    
                    let conference = teamData["conference"] as! NSDictionary
                    self.conName = conference["name"] as! String
                    
                    print(self.firstYearOfPlay)
                    print(self.venueLoc)
                    print(self.divName)
                    print(self.conName)
                    DispatchQueue.main.async { // Correct
                        self.teamVenue.text = "Venue: "+self.venueLoc;
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

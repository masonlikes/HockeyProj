//
//  ViewController.swift
//  Hockey Project
//
//  Created by Mason Lawrence on 11/9/17.
//

import UIKit

class TeamViewController: UIViewController {
    
    var urlString = "https://statsapi.web.nhl.com/api/v1/teams";
    
    var gameUrlString = ""

    var teamId = 0
    
    var lastPlays: [String] = []
    
    var venueLoc: String = ""
    var firstYearOfPlay: String = ""
    var conName: String = ""
    var divName: String = ""
    
    var periodNumStr: String = ""
    var timeInPeriodStr: String = ""
    var homeScoreStr: String = ""
    var awayScoreStr: String = ""
    var powerPlayStr: String = ""
    var homeEmptyNetStr: String = ""
    var awayEmptyNetStr: String = ""
    var homeSOGStr: String = ""
    var awaySOGStr: String = ""
    var lastPlayStr: String = ""
    
    @IBOutlet weak var teamName: UILabel!
    @IBOutlet weak var teamLogo: UIImageView!
    
    @IBOutlet weak var teamVenue: UILabel!
    @IBOutlet weak var firstYear: UILabel!
    @IBOutlet weak var teamConference: UILabel!
    @IBOutlet weak var teamDivision: UILabel!
    
    @IBOutlet weak var inGame: UILabel!
    @IBOutlet weak var periodNum: UILabel!
    @IBOutlet weak var timeInPeriod: UILabel!
    @IBOutlet weak var powerPlay: UILabel!
    @IBOutlet weak var homeEmptyNet: UILabel!
    @IBOutlet weak var awayEmptyNet: UILabel!
    @IBOutlet weak var homeScore: UILabel!
    @IBOutlet weak var awayScore: UILabel!
    @IBOutlet weak var homeSOG: UILabel!
    @IBOutlet weak var awaySOG: UILabel!
    @IBOutlet weak var lastPlay: UILabel!
    
    var team: Team = Team(teamName: "", teamLogo: UIImage(named:"KINGS"), teamId: 0);
    
    var gameTimer: Timer!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print(team.teamId)
        self.teamId = team.teamId
        urlString += "/\(team.teamId)"
        self.teamName.text = team.teamName
        self.teamLogo.image = team.teamLogo
        
        self.inGame.isHidden = true
        self.periodNum.isHidden = true
        self.timeInPeriod.isHidden = true
        self.homeScore.isHidden = true
        self.awayScore.isHidden = true
        self.powerPlay.isHidden = true
        self.homeEmptyNet.isHidden = true
        self.awayEmptyNet.isHidden = true
        self.homeSOG.isHidden = true
        self.awaySOG.isHidden = true
        self.lastPlay.isHidden = true
        
        gameTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(getGameUrl), userInfo: nil, repeats: true)
        
        getTeamData(teamUrl: urlString)
        getGameUrl()
    }
    
    //var gameTimer = Timer.scheduledTimer(timeInterval: 30.0, target: self, selector: #selector(TeamViewController.getGameUrl), userInfo: nil, repeats: true)

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func repeatThis(){
        
    }
    
    @objc func getGameUrl(){
        let date = Date()
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        print(year)
        print(month)
        print(day)
        let url = URL(string: "https://statsapi.web.nhl.com/api/v1/schedule?startDate=\(year)-\(month)-\(day)&endDate=\(year)-\(month)-\(day)")
        URLSession.shared.dataTask(with:url!) { (data, response, error) in
            if error != nil {
                print(error as Any)
            } else {
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: data!) as! NSDictionary
                    //let dates = parsedData.value(forKey: "dates") as! NSDictionary
                    let dates = (parsedData["dates"]! as! NSArray).mutableCopy() as! NSMutableArray
                    
                    let dateObj = dates[0] as! NSDictionary
                    let games = dateObj["games"] as! NSArray
                    var inLoop = true
                    var index = 0
                    while(inLoop){
                        if(index == games.count){
                            break;
                        }
                        let game = games[index] as! NSDictionary
                        let gameUrl = game["link"] as! String
                        let teams = game["teams"] as! NSDictionary
                        
                        let away = teams["away"] as! NSDictionary
                        let awayTeam = away["team"] as! NSDictionary
                        let awayTeamId = awayTeam["id"] as! Int
                        
                        let home = teams["home"] as! NSDictionary
                        let homeTeam = home["team"] as! NSDictionary
                        let homeTeamId = homeTeam["id"] as! Int
                        
                        if(homeTeamId == self.teamId || awayTeamId == self.teamId){
                            DispatchQueue.main.async {
                                self.inGame.isHidden = false;
                                self.inGame.text = "Game Day";
                            }
                            self.getGameData(gameUrl: "https://statsapi.web.nhl.com\(gameUrl)")
                            inLoop = false
                        }else{
                            index += 1;
                        }
                    }
                } catch let error as NSError {
                    print(error)
                }
            }
            }.resume()
    }
    
    func getGameData(gameUrl: String){
        let url = URL(string: gameUrl)
        URLSession.shared.dataTask(with:url!) { (data, response, error) in
            if error != nil {
                print(error as Any)
            } else {
                do {
                    
                    let parsed = try JSONSerialization.jsonObject(with: data!) as! NSDictionary
                    //stuff
                    let gameData = parsed["gameData"] as! NSDictionary
                    
                    let status = gameData["status"] as! NSDictionary
                    
                    let abstractStatus = status["abstractGameState"] as! String
                    
                    if(abstractStatus == "Live"){
                        
                        DispatchQueue.main.async {
                            self.inGame.text = "IN GAME";
                            self.periodNum.isHidden = false
                            self.timeInPeriod.isHidden = false
                            self.homeScore.isHidden = false
                            self.awayScore.isHidden = false
                            self.homeSOG.isHidden = false
                            self.awaySOG.isHidden = false
                            self.lastPlay.isHidden = false
                        }
                    
                        let teams = gameData["teams"] as! NSDictionary
                    
                        let homeTeam = teams["home"] as! NSDictionary
                        let awayTeam = teams["away"] as! NSDictionary
                    
                        let homeTeamName = homeTeam["teamName"] as! String
                        let awayTeamName = awayTeam["teamName"] as! String
                    
                        print(homeTeamName)
                        print(awayTeamName)
                    
                    
                        let liveData = parsed["liveData"] as! NSDictionary
                    
                        let plays = liveData["plays"] as! NSDictionary
                    
                        //TEAM NAME
                        //TIME
                        //EVENT: DESC
                        //PLAYERTYPE: PLAYER
                        if let currPlay = plays["currentPlay"] as? NSDictionary{
                    
                            let about = currPlay["about"] as! NSDictionary
                            let coordinates = currPlay["coordinates"] as! NSDictionary
                            if(!coordinates.allKeys.isEmpty){
                                let xCord = coordinates["x"] as! Int
                                let yCord = coordinates["y"] as! Int
                        
                                print(xCord)
                                print(yCord)
                            }
                            let result = currPlay["result"] as! NSDictionary
                            let event = result["event"] as! String
                            let description = result["description"] as! String
                            let periodOfPlay = about["ordinalNum"] as! String
                            let timeOfPlay = about["periodTime"] as! String
                            self.lastPlayStr += "\(periodOfPlay)/\(timeOfPlay) "
                            self.lastPlayStr += "\(event): \(description) "
                            
                            print(self.lastPlayStr)
                            self.lastPlays += [self.lastPlayStr]
                            self.lastPlayStr = "";
                    
                            let goals = about["goals"] as! NSDictionary
                    
                            let homeScore = goals["home"] as! Int
                            let awayScore = goals["away"] as! Int
                            
                            let lineScore = liveData["linescore"] as! NSDictionary
                        
                            let currentPeriod = lineScore["currentPeriodOrdinal"] as! String
                            let timeRemaining = lineScore["currentPeriodTimeRemaining"] as! String
                            
                            let liveTeamStats = lineScore["teams"] as! NSDictionary
                            
                            let homeLiveTeamStats = liveTeamStats["home"] as! NSDictionary
                            let awayLiveTeamStats = liveTeamStats["away"] as! NSDictionary
                            
                            let homeSOG = homeLiveTeamStats["shotsOnGoal"] as! Int
                            let awaySOG = awayLiveTeamStats["shotsOnGoal"] as! Int
                            
                            let homeSkaters = homeLiveTeamStats["numSkaters"] as! Int
                            let awaySkaters = awayLiveTeamStats["numSkaters"] as! Int
                            
                            self.powerPlayStr = "\(homeSkaters) vs \(awaySkaters)"
                            
                            self.homeSOGStr = "SOG: \(homeSOG)"
                            self.awaySOGStr = "SOG: \(awaySOG)"
                        
                    
                            print("You are here")
                    
                            self.homeScoreStr = homeTeamName + ": \(homeScore)"
                            self.awayScoreStr = awayTeamName + ": \(awayScore)"
                    
                            self.periodNumStr = currentPeriod
                            self.timeInPeriodStr = timeRemaining
                    
                            DispatchQueue.main.async {
                                self.periodNum.text = self.periodNumStr
                                self.timeInPeriod.text = self.timeInPeriodStr
                                self.homeScore.text = self.homeScoreStr
                                self.awayScore.text = self.awayScoreStr
                                self.powerPlay.text = self.powerPlayStr
                                self.homeSOG.text = self.homeSOGStr
                                self.awaySOG.text = self.awaySOGStr
                                var msg = ""
                                let count = self.lastPlays.count
                                switch(count){
                                    case 1:
                                        msg = self.lastPlays[0]
                                        self.lastPlay.text = msg
                                        break
                                    case 2:
                                        msg = "\(self.lastPlays[1])\n"
                                        msg += "\(self.lastPlays[0])\n"
                                        self.lastPlay.text = msg
                                        break
                                    case 3:
                                        msg = "\(self.lastPlays[2])\n"
                                        msg += "\(self.lastPlays[1])\n"
                                        msg += "\(self.lastPlays[0])\n"
                                        self.lastPlay.text = msg
                                        break
                                    case 4:
                                        msg = "\(self.lastPlays[3])\n"
                                        msg += "\(self.lastPlays[2])\n"
                                        msg += "\(self.lastPlays[1])\n"
                                        msg += "\(self.lastPlays[0])\n"
                                        self.lastPlay.text = msg
                                        break
                                    case 5:
                                        msg = "\(self.lastPlays[4])\n"
                                        msg += "\(self.lastPlays[3])\n"
                                        msg += "\(self.lastPlays[2])\n"
                                        msg += "\(self.lastPlays[1])\n"
                                        msg += "\(self.lastPlays[0])\n"
                                        self.lastPlay.text = msg
                                        break
                                    default:
                                        msg = "\(self.lastPlays[count - 1])\n"
                                        msg += "\(self.lastPlays[count - 2])\n"
                                        msg += "\(self.lastPlays[count - 3])\n"
                                        msg += "\(self.lastPlays[count - 4])\n"
                                        msg += "\(self.lastPlays[count - 5])\n"
                                        self.lastPlay.text = msg
                                        break
                                }
                            }
                        }
                    }
                } catch let error as NSError {
                    print(error)
                }
            }
            
            }.resume()
    }
    
    func getTeamData(teamUrl: String){
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
                    DispatchQueue.main.async {
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

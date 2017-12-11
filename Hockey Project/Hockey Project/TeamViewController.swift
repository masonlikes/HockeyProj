//
//  ViewController.swift
//  Hockey Project
//
//  Created by Mason Lawrence on 11/9/17.
//

import UIKit

class TeamViewController: UIViewController {
    
    //Roster
    
    //past game stats
    //SOG by P
    //GOALS by P
    //3 stars
    //All those stats
    
    
    var urlString = "https://statsapi.web.nhl.com/api/v1/teams";
    
    var gameUrlString = ""

    var teamId = 0
    
    var gameDay: Bool = false
    
    var playHistorys: String = ""
    
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
    var lastPlayStage: String = ""
    var lastPlayStr: String = ""
    
    var nextGameStr: String = ""
    
    var lastGameStatsStr: String = ""
    
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
    @IBOutlet weak var homeScore: UILabel!
    @IBOutlet weak var awayScore: UILabel!
    @IBOutlet weak var homeSOG: UILabel!
    @IBOutlet weak var awaySOG: UILabel!
    //@IBOutlet weak var lastPlay: UILabel!
    //@IBOutlet weak var playTable: UITableView!
    @IBOutlet weak var playHistory: UITextView!
    
    @IBOutlet weak var lastGameHeader: UILabel!
    @IBOutlet weak var lastGameStats: UITextView!
    
    
    var team: Team = Team(teamName: "", teamLogo: UIImage(named:"KINGS"), teamId: 0);
    
    var gameTimer: Timer!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let arr: [String] = []
        print("###########")
        print(arr.count)
        print("###########")
        print(team.teamId)
        self.teamId = team.teamId
        urlString += "/\(team.teamId)"
        self.teamName.text = team.teamName
        self.teamLogo.image = team.teamLogo
        
        //self.inGame.isHidden = true
        self.inGame.adjustsFontSizeToFitWidth = true
        self.periodNum.isHidden = true
        self.timeInPeriod.isHidden = true
        self.homeScore.isHidden = true
        self.awayScore.isHidden = true
        self.powerPlay.isHidden = true
        self.homeSOG.isHidden = true
        self.awaySOG.isHidden = true
        self.playHistory.isHidden = true
        self.playHistory.isEditable = false
        self.lastGameStats.isEditable = false
        //self.lastPlay.isHidden = true
        
        gameTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(getGameUrl), userInfo: nil, repeats: true)
        getLastGameStats()
        getTeamData(teamUrl: urlString)
        getGameUrl()
        getNextGame()
        gameToday()
        
        var str = "This is a line 0\n"
        
        var i = 1
        while(i <= 10){
            str += "This is a line \(i)\n"
            i += 1
        }
        self.playHistory.text = str
        //self.playTable.dataSource = lastPlays as? UITableViewDataSource
        //self.lastPlay.text = str
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getLastGameStats(){
        let date = Date()
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        print("%%%%%%%%%%%%%%%")
        print(year)
        print(month)
        print(day)
        print("%%%%%%%%%%%%%%%")
        let url = URL(string: "https://statsapi.web.nhl.com/api/v1/schedule?startDate=\(year-1)-\(month)-\(day)&endDate=\(year)-\(month)-\(day)")
        URLSession.shared.dataTask(with:url!) { (data, response, error) in
            if error != nil {
                print(error as Any)
            } else {
                do {
                    let parsedData = try JSONSerialization.jsonObject(with: data!) as! NSDictionary
                    let dates = (parsedData["dates"]! as! NSArray).mutableCopy() as! NSMutableArray
                    
                    var dateIndex = dates.count - 1
                    var gameFound = false
                    while(!gameFound){
                        if(dateIndex < 0){
                            break;
                        }
                        let dateObj = dates[dateIndex] as! NSDictionary
                        
                        let games = (dateObj["games"]! as! NSArray).mutableCopy() as! NSMutableArray
                        var gameIndex = 0
                        while(!gameFound){
                            if(gameIndex == games.count){
                                break;
                            }
                            let game = games[gameIndex] as! NSDictionary
                            
                            let status = game["status"] as! NSDictionary
                            let abstractStatus = status["abstractGameState"] as! String
                            let preGame = (abstractStatus == "Preview")
                            
                            let teams = game["teams"] as! NSDictionary
                            
                            let homeTeamObj = teams["home"] as! NSDictionary
                            let homeTeam = homeTeamObj["team"] as! NSDictionary
                            let homeTeamId = homeTeam["id"] as! Int
                            
                            let awayTeamObj = teams["away"] as! NSDictionary
                            let awayTeam = awayTeamObj["team"] as! NSDictionary
                            let awayTeamId = awayTeam["id"] as! Int
                            
                            if(!preGame && (self.teamId == homeTeamId || self.teamId == awayTeamId)){
                                let link = game["link"] as! String
                                self.setLastGameStats(gameURL: "https://statsapi.web.nhl.com\(link)")
                                gameFound = true
                            }else{
                                gameIndex += 1
                            }
                        }
                        dateIndex -= 1
                    }
                } catch let error as NSError {
                    print(error)
                }
            }
            }.resume()
    }
    
    func setLastGameStats(gameURL: String){
        let url = URL(string: gameURL)
        URLSession.shared.dataTask(with:url!) { (data, response, error) in
            if error != nil {
                print(error as Any)
            } else {
                do {
                    let parsedData = try JSONSerialization.jsonObject(with: data!) as! NSDictionary
                    //let dates = parsedData.value(forKey: "dates") as! NSDictionary
                    let liveData = parsedData["liveData"] as! NSDictionary
                    
                    let boxScore = liveData["boxscore"] as! NSDictionary
                    let teams = boxScore["teams"] as! NSDictionary
                    
                    let homeTeam = teams["home"] as! NSDictionary
                    let homeTeamData = homeTeam["team"] as! NSDictionary
                    let homeTeamName = homeTeamData["name"] as! String
                    
                    let homeTeamStats = homeTeam["teamStats"] as! NSDictionary
                    let homeTeamSkaterStats = homeTeamStats["teamSkaterStats"] as! NSDictionary
                    
                    let homeGameGoals = homeTeamSkaterStats["goals"] as! Int
                    let homeGamePIM = homeTeamSkaterStats["pim"] as! Int
                    let homeGameSOG = homeTeamSkaterStats["shots"] as! Int
                    let homeGamePPG = homeTeamSkaterStats["powerPlayGoals"] as! Int
                    let homeGamePPO = homeTeamSkaterStats["powerPlayOpportunities"] as! Int
                    let homeGameFOW = homeTeamSkaterStats["faceOffWinPercentage"] as! String
                    let homeGameBlocked = homeTeamSkaterStats["blocked"] as! Int
                    let homeGameTakeAways = homeTeamSkaterStats["takeaways"] as! Int
                    let homeGameGiveAways = homeTeamSkaterStats["giveaways"] as! Int
                    let homeGameHits = homeTeamSkaterStats["hits"] as! Int
                    
                    let awayTeam = teams["away"] as! NSDictionary
                    let awayTeamData = awayTeam["team"] as! NSDictionary
                    let awayTeamName = awayTeamData["name"] as! String
                    
                    let awayTeamStats = awayTeam["teamStats"] as! NSDictionary
                    let awayTeamSkaterStats = awayTeamStats["teamSkaterStats"] as! NSDictionary
                    
                    let awayGameGoals = awayTeamSkaterStats["goals"] as! Int
                    let awayGamePIM = awayTeamSkaterStats["pim"] as! Int
                    let awayGameSOG = awayTeamSkaterStats["shots"] as! Int
                    let awayGamePPG = awayTeamSkaterStats["powerPlayGoals"] as! Int
                    let awayGamePPO = awayTeamSkaterStats["powerPlayOpportunities"] as! Int
                    let awayGameFOW = awayTeamSkaterStats["faceOffWinPercentage"] as! String
                    let awayGameBlocked = awayTeamSkaterStats["blocked"] as! Int
                    let awayGameTakeAways = awayTeamSkaterStats["takeaways"] as! Int
                    let awayGameGiveAways = awayTeamSkaterStats["giveaways"] as! Int
                    let awayGameHits = awayTeamSkaterStats["hits"] as! Int
                    
                    self.lastGameStatsStr = "\(awayTeamName) @ \(homeTeamName)\n\n"
                    self.lastGameStatsStr += "\(awayGameGoals)    Goals    \(homeGameGoals)\n\n"
                    self.lastGameStatsStr += "\(awayGameSOG)    Shots    \(homeGameSOG)\n\n"
                    self.lastGameStatsStr += "\(awayGamePIM)    Penalty Minutes    \(homeGamePIM)\n\n"
                    self.lastGameStatsStr += "\(awayGamePPG)/\(awayGamePPO)    Power Play    \(homeGamePPG)/\(homeGamePPO)\n\n"
                    self.lastGameStatsStr += "\(awayGameFOW)%    FaceOff Win    \(homeGameFOW)%\n\n"
                    self.lastGameStatsStr += "\(awayGameBlocked)    Blocked Shots    \(homeGameBlocked)\n\n"
                    self.lastGameStatsStr += "\(awayGameTakeAways)    Take Aways    \(homeGameTakeAways)\n\n"
                    self.lastGameStatsStr += "\(awayGameGiveAways)    Give Aways    \(homeGameGiveAways)\n\n"
                    self.lastGameStatsStr += "\(awayGameHits)    Hits    \(homeGameHits)\n\n"
                    DispatchQueue.main.async {
                        self.lastGameStats.text = self.lastGameStatsStr
                    }
                } catch let error as NSError {
                    print(error)
                }
            }
        }.resume()
    }
    
    func gameToday(){
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
                        let teams = game["teams"] as! NSDictionary
                        
                        let away = teams["away"] as! NSDictionary
                        let awayTeam = away["team"] as! NSDictionary
                        let awayTeamId = awayTeam["id"] as! Int
                        let awayTeamName = awayTeam["name"] as! String
                        
                        let home = teams["home"] as! NSDictionary
                        let homeTeam = home["team"] as! NSDictionary
                        let homeTeamId = homeTeam["id"] as! Int
                        let homeTeamName = homeTeam["name"] as! String
                        var littleStr = ""
                        
                        if(self.teamId == homeTeamId){
                            littleStr = "Game Today Vs the \(awayTeamName)"
                            self.gameDay = true
                            inLoop = false
                        }else if(self.teamId == awayTeamId){
                            littleStr = "Game Today @ the \(homeTeamName)"
                            self.gameDay = true
                            inLoop = false
                        }
                        
                        if(self.gameDay){
                            DispatchQueue.main.async {
                                self.inGame.text = littleStr
                            }
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
    
    func getNextGame(){
        let date = Date()
        let calendar = Calendar.current
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: date)
        
        let year = calendar.component(.year, from: tomorrow!)
        let month = calendar.component(.month, from: tomorrow!)
        let day = calendar.component(.day, from: tomorrow!)
        
        print(year)
        print(month)
        print(day)
        let url = URL(string: "https://statsapi.web.nhl.com/api/v1/schedule?startDate=\(year)-\(month)-\(day)&endDate=\(year+1)-\(month)-\(day)")
        URLSession.shared.dataTask(with:url!) { (data, response, error) in
            if error != nil {
                print(error as Any)
            } else {
                do {
                    let parsedData = try JSONSerialization.jsonObject(with: data!) as! NSDictionary
                    let dates = (parsedData["dates"]! as! NSArray).mutableCopy() as! NSMutableArray
                    
                    var dateIndex = 0
                    var gameFound = false
                    while(!gameFound){
                        if(dateIndex == dates.count){
                            break;
                        }
                        let dateObj = dates[dateIndex] as! NSDictionary
                        let dateStr = dateObj["date"] as! String
                        
                        let games = (dateObj["games"]! as! NSArray).mutableCopy() as! NSMutableArray
                        var gameIndex = 0
                        while(!gameFound){
                            if(gameIndex == games.count){
                                break;
                            }
                            let game = games[gameIndex] as! NSDictionary
                            
                            let teams = game["teams"] as! NSDictionary
                            
                            let homeTeamObj = teams["home"] as! NSDictionary
                            let homeTeam = homeTeamObj["team"] as! NSDictionary
                            let homeTeamId = homeTeam["id"] as! Int
                            let homeTeamName = homeTeam["name"] as! String
                            
                            let awayTeamObj = teams["away"] as! NSDictionary
                            let awayTeam = awayTeamObj["team"] as! NSDictionary
                            let awayTeamId = awayTeam["id"] as! Int
                            let awayTeamName = awayTeam["name"] as! String
                            
                            if(self.teamId == homeTeamId || self.teamId == awayTeamId){
                                var littleStr = ""
                                let yStart = dateStr.index(dateStr.startIndex, offsetBy: 0)
                                let yEnd = dateStr.index(dateStr.endIndex, offsetBy: -6)
                                let yResult = dateStr[yStart..<yEnd]
                                
                                let yearStr = String(yResult)
                                
                                let mStart = dateStr.index(dateStr.startIndex, offsetBy: 5)
                                let mEnd = dateStr.index(dateStr.endIndex, offsetBy: -3)
                                let mResult = dateStr[mStart..<mEnd]
                                
                                let monthStr = String(mResult)
                                
                                let dStart = dateStr.index(dateStr.startIndex, offsetBy: 8)
                                let dEnd = dateStr.index(dateStr.endIndex, offsetBy: 0)
                                let dResult = dateStr[dStart..<dEnd]
                                
                                let dayStr = String(dResult)
                                
                                print("!!!!!!!!!!!!!!!!!")
                                print(dayStr)
                                print("!!!!!!!!!!!!!!!!!")
                                
                                if(self.teamId == homeTeamId){
                                    littleStr = "Vs the \(awayTeamName)"
                                }else{
                                    littleStr = "@ the \(homeTeamName)"
                                }
                                
                                self.nextGameStr = "Next Game: \(monthStr)/\(dayStr)/\(yearStr) \(littleStr)"
                                gameFound = true
                            }else{
                                gameIndex += 1
                            }
                        }
                        dateIndex += 1
                    }
                } catch let error as NSError {
                    print(error)
                }
                print(self.nextGameStr)
                if(!self.gameDay){
                    DispatchQueue.main.async {
                        self.inGame.text = self.nextGameStr
                        self.inGame.textAlignment = NSTextAlignment.left
                    }
                }
            }
        }.resume()
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
    
    func getPlayData(play: NSDictionary) -> String{
        var playString: String = ""
        
        let about = play["about"] as! NSDictionary
        let result = play["result"] as! NSDictionary
        
        let event = result["event"] as! String
        let description = result["description"] as! String
        let periodOfPlay = about["ordinalNum"] as! String
        let timeOfPlay = about["periodTime"] as! String
        
        playString += "\(periodOfPlay)/\(timeOfPlay) "
        playString += "\(event): \(description)\n"
        
        return playString
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
                            self.inGame.text = "IN GAME"
                            self.inGame.textAlignment = NSTextAlignment.center
                            self.periodNum.isHidden = false
                            self.timeInPeriod.isHidden = false
                            self.homeScore.isHidden = false
                            self.awayScore.isHidden = false
                            self.homeSOG.isHidden = false
                            self.awaySOG.isHidden = false
                            self.powerPlay.isHidden = false
                            self.playHistory.isHidden = false
                            self.lastGameHeader.isHidden = true
                            self.lastGameStats.isHidden = true
                            //self.lastPlay.isHidden = false
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
                        
                        let allPlays = plays["allPlays"] as! NSArray
                        
                        
                        let playCount = allPlays.count
                        
                        let lastPlay = allPlays[playCount - 1] as! NSDictionary
                        
                        let about = lastPlay["about"] as! NSDictionary
                    
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
                        
                        if(homeLiveTeamStats["goaliePulled"] as! Bool){
                            self.homeEmptyNetStr = "EMPTY NET"
                        }
                        
                        if(awayLiveTeamStats["goaliePulled"] as! Bool){
                            self.awayEmptyNetStr = "EMPTY NET"
                        }
                        
                        var homePowerPlay: String = ""
                        var awayPowerPlay: String = ""
                        
                        if(currentPeriod != "OT"){
                            if(homeSkaters < 5){
                                awayPowerPlay = "Power Play"
                            }
                        
                            if(awaySkaters < 5){
                                homePowerPlay = "Power Play"
                            }
                        }
                        
                        if(homeSkaters == awaySkaters){
                            homePowerPlay = ""
                            awayPowerPlay = ""
                        }
                        
                        self.powerPlayStr = "\(self.homeEmptyNetStr) \(homePowerPlay) \(homeSkaters) vs \(awaySkaters) \(awayPowerPlay) \(self.awayEmptyNetStr)"
                            
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
                            
                            var index = playCount - 1;
                            
                            while(index > 0){
                                if(index < playCount && index > 0){
                                    msg += "\(self.self.getPlayData(play: allPlays[index] as! NSDictionary))\n"
                                }
                                index -= 1
                            }
                            
                            self.playHistory.text = msg
                            
                            /*if(playCount == 0){
                                
                            }
                            if(playCount == 1){
                                msg = self.self.getPlayData(play: allPlays[0] as! NSDictionary)
                                self.lastPlayStage = msg
                                self.playHistorys += "\(msg)\n"
                                //self.lastPlay.text = msg
                            }else{
                                msg = self.self.getPlayData(play: allPlays[playCount - 1] as! NSDictionary)
                                if(self.lastPlayStage != msg){
                                    self.playHistorys += "\(msg)\n"
                                    print(self.playHistorys)
                                }
                                //self.lastPlay.text = msg
                            }
                            self.playHistory.text = self.playHistorys */
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

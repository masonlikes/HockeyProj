//
//  ViewController.swift
//  Hockey Project
//
//  Created by Mason Lawrence on 11/9/17.
//

import UIKit

class TeamViewController: UIViewController {
    
    let URL_HEROES = "https://statsapi.web.nhl.com/api/v1/teams";
    
    @IBOutlet weak var teamName: UILabel!
    @IBOutlet weak var teamLogo: UIImageView!
    @IBOutlet weak var followed: UILabel!
    
    //A string array to save all the names
    var nameArray = [String]()
    
    var team: Team = Team(teamName: "", teamLogo: UIImage(named:"KINGS"), teamId: 0, followed: false);

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //getJsonFromUrl();
        print(team.teamName)
        self.teamName.text = team.teamName
        self.teamLogo.image = team.teamLogo
        if(team.followed){
            self.followed.text = "Followed"
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getJsonFromUrl(){
        let url = NSURL(string: URL_HEROES)
        URLSession.shared.dataTask(with: (url as? URL)!, completionHandler: {(data, response, error) -> Void in
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                print(jsonObj!.value(forKey: "teams")!)
                if let heroeArray = jsonObj!.value(forKey: "teams") as? NSArray {
                    for heroe in heroeArray{
                        if let heroeDict = heroe as? NSDictionary {
                            if let name = heroeDict.value(forKey: "name") {
                                self.nameArray.append((name as? String)!)
                            }
                        }
                    }
                }
                OperationQueue.main.addOperation({
                    self.showNames()
                })
            }
        }).resume()
    }
    
    func showNames(){
        for name in nameArray{
            //mylabel.text = mylabel.text! + name + "\n";
            print(name);
        }
    }

}

//
//  TeamTableViewController.swift
//  Hockey Project
//
//  Created by Mason Lawrence on 11/14/17.
//

import UIKit

class TeamTableViewController: UITableViewController {
    
    //MARK: Properties
    
    public var teams = [Team]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadTeams()
        // Uncomment the following line to preserve selection between presentations
        //self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return teams.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "TeamTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TeamTableViewCell  else {
            fatalError("The dequeued cell is not an instance of TeamTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let team = teams[indexPath.row]
        
        cell.teamName.text = team.teamName
        cell.teamLogo.image = team.teamLogo
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowTeamDetails" {
            
            let detailViewController = segue.destination
                as! TeamViewController
            
            let myIndexPath = self.tableView.indexPathForSelectedRow!
            let row = myIndexPath.row
            detailViewController.team = teams[row]
        }
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: Private Methods
    
    private func loadTeams() {
        let ducks = Team(teamName: "Anaheim Ducks", teamLogo: UIImage(named: "DUCKS"), teamId: 24)
        let coyotes = Team(teamName: "Arizona Coyotes", teamLogo: UIImage(named: "COYOTES"), teamId: 53)
        let bruins = Team(teamName: "Boston Bruins", teamLogo: UIImage(named: "BRUINS"), teamId: 6)
        let sabres = Team(teamName: "Buffalo Sabres", teamLogo: UIImage(named: "SABRES"), teamId: 7)
        let flames = Team(teamName: "Calgary Flames", teamLogo: UIImage(named: "FLAMES"), teamId: 20)
        let hurricanes = Team(teamName: "Carolina Hurricanes", teamLogo: UIImage(named: "HURRICANES"), teamId: 12)
        let blackhawks = Team(teamName: "Chicago Blackhawks", teamLogo: UIImage(named: "BLACKHAWKS"), teamId: 16)
        let avalanche = Team(teamName: "Colorado Avalanche", teamLogo: UIImage(named: "AVALANCHE"), teamId: 21)
        let blue_jackets = Team(teamName: "Columbus Blue Jackets", teamLogo: UIImage(named: "BLUE_JACKETS"), teamId: 29)
        let stars = Team(teamName: "Dallas Stars", teamLogo: UIImage(named: "STARS"), teamId: 25)
        let red_wings = Team(teamName: "Detroit Red Wings", teamLogo: UIImage(named: "RED_WINGS"), teamId: 17)
        let oilers = Team(teamName: "Edmonton Oilers", teamLogo: UIImage(named: "OILERS"), teamId: 22)
        let panthers = Team(teamName: "Florida Panthers", teamLogo: UIImage(named: "PANTHERS"), teamId: 13)
        let kings = Team(teamName: "Los Angeles Kings", teamLogo: UIImage(named: "KINGS"), teamId: 26)
        let wild = Team(teamName: "Minnesota Wild", teamLogo: UIImage(named: "WILD"), teamId: 30)
        let canadiens = Team(teamName: "Montreal Canadiens", teamLogo: UIImage(named: "CANADIENS"), teamId: 8)
        let predators = Team(teamName: "Nashville Predators", teamLogo: UIImage(named: "PREDATORS"), teamId: 18)
        let devils = Team(teamName: "New Jersey Devils", teamLogo: UIImage(named: "DEVILS"), teamId: 1)
        let islanders = Team(teamName: "New York Islanders", teamLogo: UIImage(named: "ISLANDERS"), teamId: 2)
        let rangers = Team(teamName: "New York Rangers", teamLogo: UIImage(named: "RANGERS"), teamId: 3)
        let senators = Team(teamName: "Ottawa Senators", teamLogo: UIImage(named: "SENATORS"), teamId: 9)
        let flyers = Team(teamName: "Philadelphia Flyers", teamLogo: UIImage(named: "FLYERS"), teamId: 4)
        let penguins = Team(teamName: "Pittsburg Penguins", teamLogo: UIImage(named: "PENGUINS"), teamId: 5)
        let sharks = Team(teamName: "San Jose Sharks", teamLogo: UIImage(named: "SHARKS"), teamId: 28)
        let blues = Team(teamName: "St. Louis Blues", teamLogo: UIImage(named: "BLUES"), teamId: 19)
        let lightning = Team(teamName: "Tampa Bay Lightning", teamLogo: UIImage(named: "LIGHTNING"), teamId: 14)
        let maple_leafs = Team(teamName: "Toronto Maple Leafs", teamLogo: UIImage(named: "MAPLE_LEAFS"), teamId: 10)
        let canucks = Team(teamName: "Vancouver Canucks", teamLogo: UIImage(named: "CANUCKS"), teamId: 23)
        let golden_knights = Team(teamName: "Vegas Golden Knights", teamLogo: UIImage(named: "GOLDEN_KNIGHTS"), teamId: 54)
        let capitals = Team(teamName: "Washington Capitals", teamLogo: UIImage(named: "CAPITALS"), teamId: 15)
        let jets = Team(teamName: "Winnipeg Jets", teamLogo: UIImage(named: "JETS"), teamId: 52)
        
        teams += [ducks,coyotes,bruins,sabres,flames,hurricanes,blackhawks,avalanche,blue_jackets,stars,red_wings,oilers,panthers,kings,wild,canadiens,predators,devils,islanders,rangers,senators,flyers,penguins,sharks,blues,lightning,maple_leafs,canucks,golden_knights,capitals,jets]
    }

}

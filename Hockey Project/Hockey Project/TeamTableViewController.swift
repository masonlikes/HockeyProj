//
//  TeamTableViewController.swift
//  Hockey Project
//
//  Created by Mason Lawrence on 11/14/17.
//

import UIKit

class TeamTableViewController: UITableViewController {
    
    //MARK: Properties
    
    var teams = [Team]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadTeams()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TeamTableViewCell
        
        // Fetches the appropriate meal for the data source layout.
        let team = teams[indexPath.row]

        cell.teamName.text = team.teamName
        cell.teamLogo.image = team.teamLogo
        cell.followSwitch.isOn = team.followed

        return cell
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
        let ducks = Team(teamName: "Anaheim Ducks", teamLogo: UIImage(named: "DUCKS"), followed: false)
         let coyotes = Team(teamName: "Arizona Coyotes", teamLogo: UIImage(named: "COYOTES"), followed: false)
         let bruins = Team(teamName: "Boston Bruins", teamLogo: UIImage(named: "BRUINS"), followed: false)
         let sabres = Team(teamName: "Buffalo Sabres", teamLogo: UIImage(named: "SABRES"), followed: false)
         let flames = Team(teamName: "Calgary Flames", teamLogo: UIImage(named: "FLAMES"), followed: false)
         let hurricanes = Team(teamName: "Carolina Hurricanes", teamLogo: UIImage(named: "HURRICANES"), followed: false)
         let blackhawks = Team(teamName: "Chicago Blackhawks", teamLogo: UIImage(named: "Blackhawks"), followed: false)
         let avalanche = Team(teamName: "Colorado Avalanche", teamLogo: UIImage(named: "Avalanche"), followed: false)
         let blue_jackets = Team(teamName: "Columbus Blue Jackets", teamLogo: UIImage(named: "BLUE_JACKETS"), followed: false)
         let stars = Team(teamName: "Dallas Stars", teamLogo: UIImage(named: "STARS"), followed: false)
         let red_wings = Team(teamName: "Detroit Red Wings", teamLogo: UIImage(named: "RED_WINGS"), followed: false)
         let oilers = Team(teamName: "Edmonton Oilers", teamLogo: UIImage(named: "Oilers"), followed: false)
         let panthers = Team(teamName: "Florida Panthers", teamLogo: UIImage(named: "PANTHERS"), followed: false)
         let kings = Team(teamName: "Los Angeles Kings", teamLogo: UIImage(named: "KINGS"), followed: true)
         let wild = Team(teamName: "Minnesota Wild", teamLogo: UIImage(named: "WILD"), followed: false)
         let canadiens = Team(teamName: "Montreal Canadiens", teamLogo: UIImage(named: "CANADIENS"), followed: false)
         let predators = Team(teamName: "Nashville Predators", teamLogo: UIImage(named: "Predators"), followed: false)
         let devils = Team(teamName: "New Jersey Devils", teamLogo: UIImage(named: "DEVILS"), followed: false)
         let islanders = Team(teamName: "New York Islanders", teamLogo: UIImage(named: "ISLANDERS"), followed: false)
         let rangers = Team(teamName: "New York Rangers", teamLogo: UIImage(named: "RANGERS"), followed: false)
         let senators = Team(teamName: "Ottawa Senators", teamLogo: UIImage(named: "SENATORS"), followed: false)
         let flyers = Team(teamName: "Philadelphia Flyers", teamLogo: UIImage(named: "FLYERS"), followed: false)
         let penguins = Team(teamName: "Pittsburg Penguins", teamLogo: UIImage(named: "PENGUINS"), followed: false)
         let sharks = Team(teamName: "San Jose Sharks", teamLogo: UIImage(named: "SHARKS"), followed: false)
         let blues = Team(teamName: "St. Louis Blues", teamLogo: UIImage(named: "BLUES"), followed: false)
         let lightning = Team(teamName: "Tampa Bay Lightning", teamLogo: UIImage(named: "LIGHTNING"), followed: false)
         let maple_leafs = Team(teamName: "Toronto Maple Leafs", teamLogo: UIImage(named: "MAPLE_LEAFS"), followed: false)
         let canucks = Team(teamName: "Vancouver Canucks", teamLogo: UIImage(named: "CANUCKS"), followed: false)
         let golden_knights = Team(teamName: "Vegas Golden Knights", teamLogo: UIImage(named: "GOLDEN_KNIGHTS"), followed: false)
         let capitals = Team(teamName: "Washington Capitals", teamLogo: UIImage(named: "CAPITALS"), followed: false)
         let jets = Team(teamName: "Winnipeg Jets", teamLogo: UIImage(named: "JETS"), followed: false)
        
        teams += [ducks,coyotes,bruins,sabres,flames,hurricanes,blackhawks,avalanche,blue_jackets,stars,red_wings,oilers,panthers,kings,wild,canadiens,predators,devils,islanders,rangers,senators,flyers,penguins,sharks,blues,lightning,maple_leafs,canucks,golden_knights,capitals,jets]
    }

}

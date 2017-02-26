//
//  PlacesViewController.swift
//  Bucket List
//
//  Created by Katja Hollaar on 19/02/2017.
//  Copyright © 2017 Katja Hollaar. All rights reserved.
//

import UIKit

var places = [Dictionary<String, String>()]
var activePlace = -1
func updateUserPlaces(object: [Dictionary<String, String>], key: String) {
     UserDefaults.standard.set(object, forKey: key)
}

class PlacesViewController: UITableViewController {

    @IBOutlet var placesTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let userPlaces = UserDefaults.standard.object(forKey: "places") as? [Dictionary<String, String>] {
            places = userPlaces
        }
        if places.count == 1 && places[0].count == 0 {
            places.remove(at: 0)
            places.append([
                "name": "San Jose",
                "subtitle": "Costa Rica",
                "lat": "9.934739",
                "lon": "-84.087502"
            ])
        }
        updateUserPlaces(object: places, key: "places")
        
        activePlace = -1
        placesTable.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "PlaceCell")
        if let placeName = places[indexPath.row]["name"] {
            cell.textLabel?.text = placeName
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        activePlace = indexPath.row
        performSegue(withIdentifier: "toMap", sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            places.remove(at: indexPath.row)
            updateUserPlaces(object: places, key: "places")
            placesTable.reloadData()
        }
    }
/*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
*/
}

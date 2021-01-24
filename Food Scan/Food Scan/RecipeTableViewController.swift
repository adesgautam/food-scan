//
//  RecipeTableViewController.swift
//  Food Scan
//
//  Created by Adesh Gautam on 23/10/17.
//  Copyright © 2017 adeshgautam. All rights reserved.
//

import UIKit
import Alamofire

class RecipeTableViewController: UITableViewController {

    var recipesTable = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        if navigationItem.title != Data.foodGuess {
            navigationItem.title = Data.foodGuess
            getRecipe()
        }
        print("Done loading")
    }
    
    public func getRecipe() {
        print("getRecipe()")
        recipesTable.removeAll()
        let URL = "http://food-scan.herokuapp.com/get_recipe/"
        let params = [ "food": Data.foodGuess ]
        Alamofire.request(URL, method: .post, parameters: params, encoding: JSONEncoding.default)
            .responseJSON { response in
                if let JSON = response.result.value {
                    let dict = JSON as? Dictionary<String, [String]>
                    let items = dict!["recipe"]!
                    print(items)
                    for item in items{
                        self.recipesTable.append(item)
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return recipesTable.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipesCell", for: indexPath)

        // Configure the cell...
        let recipe: String = recipesTable[indexPath.row]
        print(recipe)
        if let recipeCell = cell as? RecipesCell {
            recipeCell.recipe = recipe
        }

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

}

//
//  RecipesCell.swift
//  
//
//  Created by Adesh Gautam on 23/10/17.
//

import UIKit

class RecipesCell: UITableViewCell {
    
    @IBOutlet weak var recipeLabel: UILabel!
    
    var recipe: String? {
        didSet{
            recipeLabel.text = recipe
        }
    }

}

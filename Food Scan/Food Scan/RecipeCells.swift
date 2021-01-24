//
//  RecipeCell.swift
//  Food Scan
//
//  Created by Adesh Gautam on 23/10/17.
//  Copyright © 2017 adeshgautam. All rights reserved.
//

import UIKit

class RecipeCell: UITableViewCell {

    var recipe: String? {
        didSet{
            ingredientLabel.text = recipe
        }
    }

}

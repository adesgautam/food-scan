//
//  IngredientsCell.swift
//  Food Scan
//
//  Created by Adesh Gautam on 22/10/17.
//  Copyright © 2017 adeshgautam. All rights reserved.
//

import UIKit

class IngredientsCell: UITableViewCell {

    @IBOutlet weak var ingredientLabel: UILabel!
    
    var ingredient: String? {
        didSet{
            ingredientLabel.text = ingredient
        }
    }
    
}

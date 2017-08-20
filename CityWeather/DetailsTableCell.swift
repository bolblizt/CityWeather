//
//  DetailsTableCell.swift
//  CityWeather
//
//  Created by Dominic Edwayne Rivera on 20/8/17.
//  Copyright © 2017 Dominic Edwayne Rivera. All rights reserved.
//

import UIKit

class DetailsTableCell: UITableViewCell {

    @IBOutlet weak var imageIcon:UIImageView!
    @IBOutlet weak var dayLabel:UILabel!
    @IBOutlet weak var tempLabel:UILabel!
    @IBOutlet weak var descriptLabel:UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

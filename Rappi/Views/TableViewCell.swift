//
//  TableViewCell.swift
//  Rappi
//
//  Created by Delberto Martinez on 5/16/19.
//  Copyright © 2019 Delberto Martinez. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    //Connect the outlets to display TableViewCell
    @IBOutlet weak var imageMovieLabel: UIImageView!
    @IBOutlet weak var votesLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        

    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

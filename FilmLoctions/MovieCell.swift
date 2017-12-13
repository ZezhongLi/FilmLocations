//
//  MovieCell.swift
//  FilmLoctions
//
//  Created by Neil Li on 12/12/17.
//  Copyright © 2017 Li Zezhong. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  FavoritesViewCell.swift
//  Opus
//
//  Created by Christopher Marchand on 03/12/2019.
//  Copyright © 2019 Christopher Marchand. All rights reserved.
//

import UIKit

class FavoritesViewCell: UITableViewCell {

    @IBOutlet weak var trackTitle: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var trackDuration: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

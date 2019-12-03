//
//  TopAlbumListViewCell.swift
//  Opus
//
//  Created by Christopher Marchand on 24/10/2019.
//  Copyright © 2019 Christopher Marchand. All rights reserved.
//

import UIKit

class TopAlbumListViewCell: UITableViewCell {

    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var albumTitle: UILabel!
    @IBOutlet weak var artistName: UILabel!
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

//
//  TopAlbumListViewCellTableViewCell.swift
//  Opus
//
//  Created by Christopher Marchand on 23/10/2019.
//  Copyright © 2019 Christopher Marchand. All rights reserved.
//

import UIKit

class TrackListViewCell: UITableViewCell {

    @IBOutlet weak var trackTitle: UILabel!
    @IBOutlet weak var trackDuration: UILabel!
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

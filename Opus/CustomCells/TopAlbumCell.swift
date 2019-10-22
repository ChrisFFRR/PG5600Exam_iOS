//
//  TopAlbumCellCollectionViewCell.swift
//  Opus
//
//  Created by Christopher Marchand on 19/10/2019.
//  Copyright © 2019 Christopher Marchand. All rights reserved.
//

import UIKit

class TopAlbumCell: UICollectionViewCell {
    
        @IBOutlet var albumImage: UIImageView!
        @IBOutlet var albumTitle: UILabel!
        @IBOutlet var albumArtist: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

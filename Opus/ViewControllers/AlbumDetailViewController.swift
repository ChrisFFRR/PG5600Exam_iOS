//
//  AlbumDetailViewController.swift
//  Opus
//
//  Created by Christopher Marchand on 15/10/2019.
//  Copyright © 2019 Christopher Marchand. All rights reserved.
//

import UIKit

class AlbumDetailViewController: UIViewController {

    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var albumTitle: UILabel!
    @IBOutlet weak var albumArtist: UILabel!
    
    var albumImageData = UIImage()
    var albumTitleData = ""
    var albumArtistData = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        albumImage.image = albumImageData
        albumTitle.text = albumTitleData
        print(albumTitleData)
        albumArtist.text = albumArtistData
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


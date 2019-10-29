//
//  AlbumDetailViewController.swift
//  Opus
//
//  Created by Christopher Marchand on 15/10/2019.
//  Copyright © 2019 Christopher Marchand. All rights reserved.
//

import UIKit

class AlbumDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var albumImage: UIImageView!
       @IBOutlet weak var albumTitle: UILabel!
       @IBOutlet weak var albumArtist: UILabel!
       @IBOutlet weak var trackContainer: UITableView!
   
    
    var albumTracks = [Album]() {
        didSet{
            DispatchQueue.main.async {
                self.trackContainer.reloadData()
            }
        }
    }

    var albumImageStr = ""
    var albumTitleData = ""
    var albumArtistData = ""
    var albumIdString = ""
   
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        //register trackListCell
        let trackInfoNib = UINib(nibName: "TrackListViewCell", bundle: nil)
        trackContainer.register(trackInfoNib, forCellReuseIdentifier: "TrackListViewCell")
        trackContainer.delegate = self
        trackContainer.dataSource = self
        
        trackContainer.layer.cornerRadius = 10

        Utils.convertStrToUIImage(albumImageStr){ albumCover in
            self.albumImage.image = albumCover
        }

        albumTitle.text = albumTitleData
        albumArtist.text = albumArtistData
        
      
            let albumIntID = Int(self.albumIdString)
            
            let albumTracks = NetworkHandler( from: "https://theaudiodb.com/api/v1/json/1/track.php?m=\(albumIntID!)")
            
            albumTracks.getAlbumTracks { [weak self] result in
                self?.albumTracks = result!
            }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albumTracks.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TrackListViewCell", for: indexPath) as? TrackListViewCell else {
            fatalError("Could not dequeue TrackListViewCell")
        }
        cell.trackTitle.text = albumTracks[indexPath.row].strTrack
        cell.trackDuration.text = convertFromStringToCorrectTime(from: albumTracks[indexPath.row].strDuration)
        
        return cell
    }
    
    private func convertFromStringToCorrectTime(from stringDur: String) -> String {
        let timeInt = NSInteger(stringDur)
        
        let minutes = timeInt! / 60000
        let seconds = (timeInt! / 1000) % 60
        
        let converted = NSString(format: "%d:%.2d",minutes, seconds)
        
        return String(converted)
        
    }

}




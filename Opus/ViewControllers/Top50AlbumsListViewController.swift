//
//  Top50AlbumsListViewController.swift
//  Opus
//
//  Created by Christopher Marchand on 22/10/2019.
//  Copyright © 2019 Christopher Marchand. All rights reserved.
//

import UIKit

class Top50AlbumsListViewController: UITableViewController{
   
  
    var totalAlbums: [TopAlbum] = []
   
    override func viewDidLoad() {
        super.viewDidLoad()
       
        print("Total albums in ListVC \(totalAlbums.count)")
        
        
        let topAlbumNib = UINib(nibName: "TopAlbumListViewCell", bundle: nil)
        tableView.register(topAlbumNib, forCellReuseIdentifier: "TopAlbumListViewCell")
    
        
        tableView.reloadData()
        
    }
    
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return totalAlbums.count
     }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TopAlbumListViewCell", for: indexPath) as? TopAlbumListViewCell else {
            fatalError("Unable to dequeue TopAlbumCell")
        }
        
        
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 3
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        
        let album = totalAlbums[indexPath.row]
        
        cell.albumImage.image = Utils.convertStrToUIImage(album.strAlbumThumb)
        cell.albumTitle.text = album.strAlbum
        cell.artistName.text = album.strArtist
        
        
        return cell
    }
    
  
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let albumDetailVC = storyboard.instantiateViewController(withIdentifier: "AlbumDetailViewController") as? AlbumDetailViewController
        
        let albumDetailData = totalAlbums[indexPath.row]
        
        
        Utils.setUpAndShowModal(album: albumDetailData, albumDetailVC, senderVC: self)
   
    }
  

}


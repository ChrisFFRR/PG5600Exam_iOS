//
//  Top50AlbumsViewController.swift
//  Opus
//
//  Created by Christopher Marchand on 12/10/2019.
//  Copyright © 2019 Christopher Marchand. All rights reserved.
//

import UIKit


protocol AlbumDelegate {
    func didSendAlbums(_ albums: [TopAlbum])
}

class Top50AlbumsViewController: UICollectionViewController {
    
    var albumDelegate: AlbumDelegate?
    var topAlbumList = [TopAlbum]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
               self.albumDelegate?.didSendAlbums(self.topAlbumList)
            }
        }
    }
    var collectionViewFlowLayout:  UICollectionViewFlowLayout!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //register topalbum cell
        let topAlbumNib = UINib(nibName: "TopAlbumCell", bundle: nil)
        collectionView.register(topAlbumNib, forCellWithReuseIdentifier: "TopAlbumCell")
        
        let topAlbums = NetworkHandler(from: "https://theaudiodb.com/api/v1/json/1/mostloved.php?format=album")
    
        
        topAlbums.getTopAlbums { [weak self] result in
            guard let result = result else {
                print("Could not fetch Albums")
                return
            }
            self?.topAlbumList = result
        }
    
    }
    override func viewWillLayoutSubviews() {
        if collectionViewFlowLayout == nil {
            let numberOfItemsRow:  CGFloat = 2
            let lineSpacing: CGFloat = 15
            let interItemSpacing: CGFloat = 15
            let width = (collectionView.frame.width - (numberOfItemsRow - 1) * interItemSpacing) / numberOfItemsRow
            
            collectionViewFlowLayout = UICollectionViewFlowLayout()
            collectionViewFlowLayout.itemSize = CGSize(width: CGFloat(width), height: CGFloat(230))
            collectionViewFlowLayout.scrollDirection = .vertical
            collectionViewFlowLayout.minimumLineSpacing = lineSpacing
            collectionViewFlowLayout.minimumInteritemSpacing = interItemSpacing
            collectionViewFlowLayout.sectionInset.top = CGFloat(15)
            
            
            collectionView.setCollectionViewLayout(collectionViewFlowLayout, animated: true)
        }
    }
    


    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return topAlbumList.count
    }
    
 
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopAlbumCell", for: indexPath) as? TopAlbumCell else {
            fatalError("Unable to dequeue TopAlbumCell")
        }
        
        let album = topAlbumList[indexPath.row]
        
        cell.albumImage.image = convertStrToUIImage(album)
        cell.albumArtist.text = album.strArtist
        cell.albumTitle.text = album.strAlbum
        
        // Add rounded corners
        cell.contentView.layer.masksToBounds = true
        cell.layer.cornerRadius = 10
        
      
        
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let albumDetailVC = storyboard.instantiateViewController(withIdentifier: "AlbumDetailViewController") as? AlbumDetailViewController
        
        let albumDetailView = topAlbumList[indexPath.row]
        
        albumDetailVC?.albumImageData = convertStrToUIImage(albumDetailView)
        albumDetailVC?.albumTitleData = albumDetailView.strAlbum
        albumDetailVC?.albumArtistData = albumDetailView.strArtist
        albumDetailVC?.albumIdString = albumDetailView.idAlbum
        
        //https://stackoverflow.com/questions/25444213/presenting-viewcontroller-with-navigationviewcontroller-swift
        let navController = UINavigationController(rootViewController: albumDetailVC!)
        navController.setNavigationBarHidden( true, animated: true)
        self.present(navController, animated: true)
        
    }
    
   

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    

    fileprivate func convertStrToUIImage(_ album: TopAlbum) -> UIImage {
           let imageUrl = URL(string: album.strAlbumThumb)
           if let data = try? Data(contentsOf: imageUrl!) {
               let image: UIImage = UIImage(data: data)!
               return image
           } else {
               fatalError()
           }
       }
}


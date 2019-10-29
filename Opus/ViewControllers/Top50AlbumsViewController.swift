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
    
    var topAlbumList = [TopAlbum]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                print("Total albums in GridVC = \(self.topAlbumList.count)")
            }
        }
    }
    var collectionViewFlowLayout:  UICollectionViewFlowLayout!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //register topalbum cell
        let topAlbumNib = UINib(nibName: "TopAlbumCell", bundle: nil)
        collectionView.register(topAlbumNib, forCellWithReuseIdentifier: "TopAlbumCell")

        DispatchQueue.global(qos: .background).async {
            let topAlbums = NetworkHandler(from: "https://theaudiodb.com/api/v1/json/1/mostloved.php?format=album")
            topAlbums.getTopAlbums { [weak self] result in
                guard let result = result else {
                    print("Could not fetch Albums")
                    return
                }
                self?.topAlbumList = result
            }
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
        return topAlbumList.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopAlbumCell", for: indexPath) as? TopAlbumCell else {
            fatalError("Unable to dequeue TopAlbumCell")
        }
        
        let album = topAlbumList[indexPath.row]
        
        // Add rounded corners
        cell.contentView.layer.masksToBounds = true
        cell.layer.cornerRadius = 10
        
        Utils.convertStrToUIImageReturn(album.strAlbumThumb) { uiImage in
            DispatchQueue.main.async {
                cell.albumImage.image = uiImage
            }
        }
        
        cell.albumArtist.text = album.strArtist
        cell.albumTitle.text = album.strAlbum
                 
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let albumDetailVC = storyboard.instantiateViewController(withIdentifier: "AlbumDetailViewController") as? AlbumDetailViewController
        
        let albumDetailData = topAlbumList[indexPath.row]
        
        Utils.setUpAndShowModal(album: albumDetailData, albumDetailVC, senderVC: self)
        
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
    
}

class Utils {
    
    static func convertStrToUIImage(_ albumUrl: String) -> UIImage {
        let imageUrl = URL(string: albumUrl)
        
        if let data = try? Data(contentsOf: imageUrl!) {
            let image: UIImage = UIImage(data: data)!
            return image
        } else {
            fatalError()
        }
    }
    
    static func convertStrToUIImageReturn(_ albumUrl: String, completion: @escaping(UIImage) -> Void) {
        let imageUrl = URL(string: albumUrl)
        DispatchQueue.global(qos: .background).async {
           if let data = try? Data(contentsOf: imageUrl!) {
            let image: UIImage = UIImage(data: data)!
            completion(image)
           } else {
            fatalError()
            }
        }
    }
    
    static func setUpAndShowModal( album: TopAlbum, _ albumDetailVC: AlbumDetailViewController?, senderVC: UIViewController) {
         
          
          albumDetailVC?.albumImageData = Utils.convertStrToUIImage(album.strAlbumThumb)
          albumDetailVC?.albumTitleData = album.strAlbum
          albumDetailVC?.albumArtistData = album.strArtist
          albumDetailVC?.albumIdString = album.idAlbum
          
          
          let navController = UINavigationController(rootViewController: albumDetailVC!)
          navController.setNavigationBarHidden( true, animated: true)
          senderVC.present(navController, animated: true)
      }
}


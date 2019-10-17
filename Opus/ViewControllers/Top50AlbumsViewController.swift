//
//  Top50AlbumsViewController.swift
//  Opus
//
//  Created by Christopher Marchand on 12/10/2019.
//  Copyright © 2019 Christopher Marchand. All rights reserved.
//

import UIKit




class Top50AlbumsViewController: UICollectionViewController {
    var topAlbumList = [TopAlbum]() {
        
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.navigationItem.title = "Top \(self.topAlbumList.count) albums"
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        

        let topAlbums = NetworkHandler(from: "https://theaudiodb.com/api/v1/json/1/mostloved.php?format=album")
        
        /*
        topAlbums.request(type: AlbumResponse.self) {  result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let albums):
              
                print(albums)
                //self?.topAlbumList = albums
        }
 */
        
        topAlbums.getTopAlbums { [weak self] result in
            
            self?.topAlbumList = result!
        
        }
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return topAlbumList.count
    }

   
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopAlbum", for: indexPath) as? Top50AlbumCell else {
            fatalError("Unable to dequeue Top50AlbumCell")
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
    //https://stackoverflow.com/questions/25444213/presenting-viewcontroller-with-navigationviewcontroller-swift
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let albumDetailVC = storyboard?.instantiateViewController(withIdentifier: "AlbumDetailViewController") as? AlbumDetailViewController
        
        let albumDetailView = topAlbumList[indexPath.row]
        
        albumDetailVC?.albumImageData = convertStrToUIImage(albumDetailView)
        albumDetailVC?.albumTitleData = albumDetailView.strAlbum
        albumDetailVC?.albumArtistData = albumDetailView.strArtist
        let navController = UINavigationController(rootViewController: albumDetailVC!)
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

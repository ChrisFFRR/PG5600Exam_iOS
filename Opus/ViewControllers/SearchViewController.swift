//
//  SearchViewController.swift
//  Opus
//
//
//  https://www.raywenderlich.com/4363809-uisearchcontroller-tutorial-getting-started
//

import UIKit

class SearchViewController: UIViewController, UISearchResultsUpdating, UICollectionViewDelegate, UICollectionViewDataSource {
   
    
   
    @IBOutlet weak var searchContainer: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var collectionViewFlowLayout: UICollectionViewFlowLayout!
    

    let searchController = UISearchController(searchResultsController: nil)
    var filteredAlbums: [TopAlbum] = []
    var albums: [TopAlbum] = []
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let topAlbums =  NetworkHandler(from: "https://theaudiodb.com/api/v1/json/1/mostloved.php?format=album")
        topAlbums.getTopAlbums {[weak self] result in
            guard let result = result else {
                print("Could not fetch Albums")
                return
            }
            self?.albums += result
        }
        
       
       
    
        //register topalbum cell
               let topAlbumNib = UINib(nibName: "TopAlbumCell", bundle: nil)
               collectionView.register(topAlbumNib, forCellWithReuseIdentifier: "TopAlbumCell")
        
        
        searchController.searchBar.sizeToFit()
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Top 50 Albums"
        definesPresentationContext = true
        extendedLayoutIncludesOpaqueBars = true
        searchController.searchBar.barStyle = .black
        searchContainer.addSubview(searchController.searchBar)
        
      
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredAlbums.count
       }
       
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopAlbumCell", for: indexPath) as! TopAlbumCell
        
        let albumDetail = filteredAlbums[indexPath.row]
        cell.albumArtist.text = albumDetail.strArtist
        cell.albumTitle.text = albumDetail.strAlbum
        
        Utils.convertStrToUIImage(albumDetail.strAlbumThumb) { uiImage in
            cell.albumImage.image = uiImage
        }
        
        return cell
       }
    
    
    func filterContextOnSearch(_ input: String) {
        
        filteredAlbums = albums.filter { (album: TopAlbum) -> Bool in
            return album.strArtist.lowercased().contains(input.lowercased())
        }
        collectionView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContextOnSearch(searchBar.text!)
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

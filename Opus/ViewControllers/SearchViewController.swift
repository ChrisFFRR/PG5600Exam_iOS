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
        
        albums += [TopAlbum(idAlbum: "001", idArtist: "010", strAlbum: "Test Album", strArtist: "Test Artist", strArtistStripped: "Test", intYearReleased: "2019", strGenre: "TestCore", strAlbumThumb: "imageString"), TopAlbum(idAlbum: "001", idArtist: "010", strAlbum: "Test Album", strArtist: "Test Artist", strArtistStripped: "Test", intYearReleased: "2019", strGenre: "TestCore", strAlbumThumb: "imageString"),TopAlbum(idAlbum: "001", idArtist: "010", strAlbum: "Test Album", strArtist: "Test Artist", strArtistStripped: "Test", intYearReleased: "2019", strGenre: "TestCore", strAlbumThumb: "imageString"),TopAlbum(idAlbum: "001", idArtist: "010", strAlbum: "Test Album", strArtist: "Test Artist", strArtistStripped: "Test", intYearReleased: "2019", strGenre: "TestCore", strAlbumThumb: "imageString"),TopAlbum(idAlbum: "001", idArtist: "010", strAlbum: "Test Album", strArtist: "Test Artist", strArtistStripped: "Test", intYearReleased: "2019", strGenre: "TestCore", strAlbumThumb: "imageString"),TopAlbum(idAlbum: "001", idArtist: "010", strAlbum: "Test Album", strArtist: "Test Artist", strArtistStripped: "Test", intYearReleased: "2019", strGenre: "TestCore", strAlbumThumb: "imageString")]
       
    
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredAlbums.count
       }
       
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopAlbumCell", for: indexPath) as! TopAlbumCell
        
        let albumDetail = filteredAlbums[indexPath.row]
        cell.albumArtist.text = albumDetail.strArtist
        cell.albumTitle.text = albumDetail.strAlbum
        
        return cell
       }
    
    
    func filterContextOnSearch(_ input: String) {
        
        filteredAlbums = albums.filter { (album: TopAlbum) -> Bool in
            return album.strAlbum.lowercased().contains(input.lowercased())
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
